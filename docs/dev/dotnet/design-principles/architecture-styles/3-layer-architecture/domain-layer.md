# Domain Layer

Domain Layer can be implemented using patterns:
- Transaction Script
- Table Module
- Domain Model
    - DDD Domain Model

### Transaction Script

The simplest way to describe business logic within the `Transaction Script` pattern is to create a script that represents a business transaction. This script explicitly defines the steps involved in the business process, and it can call upon other transaction scripts to perform sub-tasks.

```csharp
using DataAccessLayer;

namespace DomainLayer
{
    public class CustomerService(ICustomerGateway customerGateway)
    {
        public async Task ChangeCustomerName(Guid customerId, string firstName, string secondName)
        {
            ArgumentNullException.ThrowIfNullOrEmpty(firstName);
            ArgumentNullException.ThrowIfNullOrEmpty(firstName);

            CustomerNameDto nameDto = customerGateway.GetCustormerFirstName(customerId);

            if (nameDto.FirstName == firstName || nameDto.SecondName == secondName)
            {
                throw new DomainException("Name is the same.");
            }

            await customerGateway.ChangeCustromerName(customerId, firstName, secondName);
        }

        public async Task ChangeCustomerAddress(Guid customerId, string city, string address) {
            ArgumentException.ThrowIfNullOrEmpty(city);
            ArgumentException.ThrowIfNullOrEmpty(address);

            if (city.Length > 50 || address.Length > 100)
            {
                throw new DomainException("City or address is too long.");
            }

            await customerGateway.ChangeCustomerAddress(customerId, city, address);
        }
    }
}

namespace DataAccessLayer
{
    public class CustomerNameDto
    {
        public string FirstName { get; set; }

        public string SecondName { get; set; }
    }

    public interface ICustomerGateway
    {
        CustomerNameDto GetCustormerFirstName(Guid customerId);

        Task ChangeCustromerName(Guid customerId, string firstName, string secondName);
    }

    public class CustomerGateway : ICustomerGateway
    {
        public CustomerNameDto GetCustormerFirstName(Guid customerId)
        {
            // Get data from database
        }
        public async Task ChangeCustromerName(Guid customerId, string firstName, string secondName)
        {
            // Update data in database
        }
    }
}
```

##### Pros of Transaction Script:

**Simplicity:**

- Easy to understand and implement, especially for simpler applications.
- Minimal upfront design required.
- Well-suited for procedural programming languages.

**Performance:**

- Can be efficient for straightforward transactions.
- Direct database access can minimize overhead in some cases.

##### Cons of Transaction Script:

**Code Duplication:**

- Business logic can be scattered across multiple scripts, leading to redundancy.
- Difficult to maintain and update as the application grows.

**Limited Reusability:**

`Business rules` are tightly coupled with the database and specific transactions.
Reusing logic across different use cases can be challenging.

**Scalability Issues:**

As complexity increases, scripts can become large and difficult to manage.
Maintaining consistency and preventing errors can be more challenging.

**Poor Object-Oriented Design:**

Often leads to procedural code and limited encapsulation of business logic.

### Table Module

A Table Module represents a single instance responsible for managing the business logic associated with all rows within a specific database `table` or `view`.

One-to-one mapping principle is adhered, where `each database table` is directly linked to a corresponding `class` within the domain logic layer. Clients interact with only a single instance of this class for each table.

Comparing to `Transaction Script`, the Table Module pattern is more object-oriented and utilizes classes to represent tables within the database.Generally with `Table Module` pattern it is easier and faster to organized and create new code.

However, the `Table Module` pattern remains a `data-centric` approach and lacks a clear separation between `business logic` and `data access logic`.

The `Table Module` pattern is well-suited for small applications with `simple business logic` and a `limited number of tables`.

Using this pattern, it becomes challenging to test the business logic effectively due to the tight coupling between business logic and data access logic.

`Managing database transactions` can be difficult because the `data access logic` is intertwined with the `business logic`.

To facilitate the management of database transactions, an additional layer – the `Service Layer` – can be introduced above the Domain Layer. And within the Service Layer, the `Unit of Work` pattern can be employed to effectively manage database transactions.

##### Exmaple

In this example, in the `PresentationLayer` has several methods to imitate real-world application.

The `CreateHotelWithRoomsAndBookings` method creates a hotel with two rooms and two bookings.

The `CancellAllBookigsInAllHotes` method cancels all bookings in all hotels.

In the `DomainLayer`, there are three classes - table modules: Hotel, Room, and Booking.

The Hotel class can create a hotel, get a hotel by id, get all hotels, save a hotel, and cancel all bookings in all hotels.

The Room class can create a room and save a room.

The Booking class can create a booking, save a booking, and remove all bookings by hotel id.

```csharp

using DataAccessLayer;
using DomainLayer;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using PresentationLayer;

await new MainController().Main();

namespace PresentationLayer
{
    class MainController
    {

        public async Task Main()
        {
            using var dbContext = new AppDbContext();
            var isCreated = await dbContext.Database.EnsureCreatedAsync();
            var script = dbContext.Database.GenerateCreateScript();

            await CreateHotelWithRoomsAndBookings();

            await CancellAllBookigsInAllHotes();
        }

        private async Task CreateHotelWithRoomsAndBookings()
        {
            using var dbContext = new AppDbContext();
            var hotel = await Hotel.CreateHotel(dbContext, "Hotel 1");
            var room1 = await Room.CreateRoom(dbContext, hotel.Id, 101, 2);
            var room2 = await Room.CreateRoom(dbContext, hotel.Id, 102, 3);
            var booking1 = await Booking.CreateBooking(dbContext, room1.Id, hotel.Id, DateTime.Now.AddDays(1), 2);
            var booking2 = await Booking.CreateBooking(dbContext, room2.Id, hotel.Id, DateTime.Now.AddDays(2), 3);
        }

        private async Task CancellAllBookigsInAllHotes()
        {
            using var dbContext = new AppDbContext();

            await new Hotel(dbContext).CancellAllBookingsInAllHotels();
        }
    }
}


namespace DomainLayer
{
    public class Hotel(AppDbContext dbContext)
    {
        private Hotel(AppDbContext dbContext, string name) : this(dbContext)
        {
            this.Id = Guid.NewGuid();
            this.Name = name;
        }

        public static async Task<Hotel> CreateHotel(AppDbContext dbContext, string name)
        {
            var hotel = new Hotel(dbContext, name);

            await hotel.Save();

            return hotel;
        }

        public Guid Id { get; set; }

        public string Name { get; set; }

        public ValueTask<Hotel?> TryGetById(Guid id) => dbContext.Hotels.FindAsync(id);

        public async Task<IEnumerable<Hotel>> GetAllHotels() => await dbContext.Hotels.ToListAsync();

        public async Task Save()
        {
            await dbContext.Hotels.AddAsync(this);

            await dbContext.SaveChangesAsync();
        }

        public async Task CancellAllBookingsInAllHotels()
        {
            var hotels = await GetAllHotels();

            foreach (var hotel in hotels)
            {
                await new Booking(dbContext).RemoveAllBookingsByHotelId(hotel.Id);
            }
        }
    }

    public class Room(AppDbContext dbContext)
    {
        private Room(AppDbContext dbContext, Guid hotelId, int roomNumber, int capacity) : this(dbContext)
        {
            this.Id = Guid.NewGuid();
            this.HotelId = hotelId;
            this.RoomNumber = roomNumber;
            this.Capacity = capacity;
        }

        public static async Task<Room> CreateRoom(AppDbContext dbContext, Guid hotelId, int roomNumber, int capacity)
        {
            var room = new Room(dbContext, hotelId, roomNumber, capacity);

            await room.Save();

            return room;
        }

        public Guid Id { get; set; }

        public Guid HotelId { get; set; }

        public int RoomNumber { get; set; }

        public int Capacity { get; set; }

        public async Task Save()
        {
            await dbContext.Rooms.AddAsync(this);

            await dbContext.SaveChangesAsync();
        }
    }

    public class Booking(AppDbContext dbContext)
    {
        private Booking(AppDbContext dbContext, Guid roomId, Guid hotelId, DateTime date, int duration) : this(dbContext)
        {
            // Execute business logic here
            if (duration < 1)
            {
                throw new ArgumentException("Duration must be at least 1 day");
            }

            if (date < DateTime.Now)
            {
                throw new ArgumentException("Date must be in the future");
            }

            this.Id = Guid.NewGuid();
            this.RoomId = roomId;
            this.HotelId = hotelId;
            this.Date = date;
            this.Duration = duration;
        }

        public static async Task<Booking> CreateBooking(AppDbContext dbContext, Guid roomId, Guid hotelId, DateTime date, int duration)
        {
            var booking = new Booking(dbContext, roomId, hotelId, date, duration);

            await booking.Save();

            return booking;
        }

        public Guid Id { get; set; }

        public Guid RoomId { get; set; }

        public Guid HotelId { get; set; }

        public DateTime Date { get; set; }

        public int Duration { get; set; }

        public async Task Save()
        {
            await dbContext.Bookings.AddAsync(this);

            await dbContext.SaveChangesAsync();
        }

        public async Task RemoveAllBookingsByHotelId(Guid hotelId)
        {
            var bookings = await dbContext.Bookings.Where(b => b.HotelId == hotelId).ToListAsync();

            dbContext.Bookings.RemoveRange(bookings);

            await dbContext.SaveChangesAsync();
        }
    }
}

namespace DataAccessLayer
{
    public class AppDbContext : DbContext
    {
        public DbSet<Hotel> Hotels { get; set; }

        public DbSet<Booking> Bookings { get; set; }

        public DbSet<Room> Rooms { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var keepAliveConnection = new SqliteConnection("DataSource=myshareddb;mode=memory;cache=shared");
            keepAliveConnection.Open();

            optionsBuilder.UseSqlite(keepAliveConnection);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Hotel>()
                .ToTable("hotel");

            modelBuilder.Entity<Room>()
                .ToTable("room");

            modelBuilder.Entity<Booking>()
                .ToTable("booking");
        }
    }
}

```
```sql
CREATE TABLE "booking" (
    "Id" TEXT NOT NULL CONSTRAINT "PK_booking" PRIMARY KEY,
    "RoomId" TEXT NOT NULL,
    "HotelId" TEXT NOT NULL,
    "Date" TEXT NOT NULL,
    "Duration" INTEGER NOT NULL
);

CREATE TABLE "hotel" (
    "Id" TEXT NOT NULL CONSTRAINT "PK_hotel" PRIMARY KEY,
    "Name" TEXT NOT NULL
);

CREATE TABLE "room" (
    "Id" TEXT NOT NULL CONSTRAINT "PK_room" PRIMARY KEY,
    "HotelId" TEXT NOT NULL,
    "RoomNumber" INTEGER NOT NULL,
    "Capacity" INTEGER NOT NULL
);

```

##### Pros Table Model pattern

**Simplicity:**
- Relatively straightforward to implement, especially for applications with a strong focus on database operations.

**Database-Centric:** 
- Leverages the strengths of relational databases and their query languages (e.g., SQL).

##### Cons Table Model pattern

**Limited Object-Oriented Features**
- Doesn't fully embrace object-oriented principles like `inheritance` and `polymorphism`.
- Can lead to `procedural code` and limited flexibility.

**Tight Coupling to Database**
- Changes in the database schema can significantly impact the table modules.
- Difficult to adapt to changes in data storage mechanisms.

**Limited Reusability:**
- Business logic is often tightly coupled to specific database tables.
- Reusing logic across different use cases can be challenging.

**Scalability Issues:**
- As the application grows and complexity increases, managing numerous table modules can become cumbersome.


### Domain Model

Domain models are a crucial aspect of object-oriented programming, representing real-world entities and their relationships within a software system. They encapsulate both data and behavior, leading to more modular, maintainable, and reusable code.

It is important to understand that the primary focus of a domain model is not on data itself, but on the behavior that it operates on. A Domain Model unites functions that are most likely to be used together.

Comparing to `Table Module` pattern, `Domain Model` doen't depend on the Database. It doen't matter where and how the object will be saved.

In the long term, the code written with a `Domain Model` is easier to support and maintain compared to the `Table Module` pattern and especially 'Transaction Script'.

##### Example

The `DomainLayer` has domain class models `VipRoom` and `SimpleRoom`, while the `DataAccess layer` saves both in the `same table`.

```csharp
using DataAccessLayer;
using DomainLayer;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using PresentationLayer;

await new MainController().Main();

namespace PresentationLayer
{
    public class MainController
    {
        public async Task Main()
        {
            using var dbContext = new AppDbContext();
            var isCreated = await dbContext.Database.EnsureCreatedAsync();
            var script = dbContext.Database.GenerateCreateScript();

            await CreateHotelWithRoomsAndBookings();

            await CancellAllBookigsInAllHotes();
        }

        private async Task CreateHotelWithRoomsAndBookings()
        {
            using var dbContext = new AppDbContext();

            var hotel = new Hotel("Hotel1");
            await dbContext.AddAsync(hotel);

            await dbContext.SaveChangesAsync();

            var vipRoom = new VipRoom(hotel, 1, 2, true);
            var simpleRoom = new SimpleRoom(hotel, 2, 2);
            await dbContext.AddAsync(vipRoom);
            await dbContext.AddAsync(simpleRoom);

            await dbContext.SaveChangesAsync();

            var booking1 = new Booking(simpleRoom, hotel, DateTime.Now.AddDays(1), 2);
            var booking2 = new Booking(vipRoom, hotel, DateTime.Now.AddDays(2), 3);

            await dbContext.AddAsync(booking1);
            await dbContext.AddAsync(booking2);

            await dbContext.SaveChangesAsync();
        }

        private async Task CancellAllBookigsInAllHotes()
        {
            using var dbContext = new AppDbContext();

            var allHotels = await dbContext.Hotels.Include(hotel=>hotel.Bookings).ToListAsync();

            foreach (var hotel in allHotels)
            {
                hotel.CancellAllBookings();
            }

            dbContext.UpdateRange(allHotels);

            await dbContext.SaveChangesAsync();
        }
    }
}

namespace DomainLayer
{
    public class Hotel
    {
        public Hotel() { }

        public Hotel(string name)
        {
            this.Id = Guid.NewGuid();
            this.Name = name;
        }

        public Guid Id { get; set; }

        public string Name { get; set; }

        public virtual ICollection<VipRoom> VipRooms { get; set; } = [];

        public virtual ICollection<SimpleRoom> SimpleRooms { get; set; } = [];

        public virtual ICollection<Booking> Bookings { get; set; } = [];

        public void AddBooking(Booking booking)
        {
            if (booking.Date < DateTime.Now)
            {
                throw new ArgumentException("Date must be in the future");
            }

            if (booking.Duration < 1)
            {
                throw new ArgumentException("Duration must be at least 1 day");
            }

            if (this.Bookings.Any(b => b.Date == booking.Date))
            {
                throw new ArgumentException("There is already a booking for this date");
            }

            this.Bookings.Add(booking);
        }
        public void CancellAllBookings()
        {
            this.Bookings.Clear();
        }
    }

    public abstract class Room
    {
        public Room() { }

        public Room(Hotel hotel, int roomNumber, int capacity)
        {
            this.Id = Guid.NewGuid();
            this.Hotel = hotel;
            this.RoomNumber = roomNumber;
            this.Capacity = capacity;
        }

        public Guid Id { get; set; }

        public int RoomNumber { get; set; }

        public int Capacity { get; set; }

        public virtual Hotel Hotel { get; set; }
    }

    public sealed class SimpleRoom : Room
    {
        public SimpleRoom() { }

        public SimpleRoom(Hotel hotel, int roomNumber, int capacity) : base(hotel, roomNumber, capacity)
        {
        }
    }

    public sealed class VipRoom : Room
    {
        public VipRoom() { }

        public VipRoom(Hotel hotel, int roomNumber, int capacity, bool hasJacuzzi) : base(hotel, roomNumber, capacity)
        {
            HasJacuzzi = hasJacuzzi;
        }

        public bool HasJacuzzi { get; set; }
    }

    public class Booking
    {
        public Booking() { }

        public Booking(Room room, Hotel hotel, DateTime date, int duration)
        {
            if (duration < 1)
            {
                throw new ArgumentException("Duration must be at least 1 day");
            }

            if (date < DateTime.Now)
            {
                throw new ArgumentException("Date must be in the future");
            }

            this.Id = Guid.NewGuid();
            this.Room = room;
            this.Hotel = hotel;
            this.Date = date;
            this.Duration = duration;
        }

        public Guid Id { get; set; }

        public DateTime Date { get; set; }

        public int Duration { get; set; }

        public virtual Room Room { get; set; }

        public virtual Hotel Hotel { get; set; }
    }
}

namespace DataAccessLayer
{
    public class AppDbContext : DbContext
    {
        public DbSet<Hotel> Hotels { get; set; }

        public DbSet<VipRoom> VipRooms { get; set; }

        public DbSet<SimpleRoom> SimpleRooms { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            var keepAliveConnection = new SqliteConnection("DataSource=myshareddb;mode=memory;cache=shared");
            keepAliveConnection.Open();

            optionsBuilder.UseSqlite(keepAliveConnection);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // VipRoom and SimpleRoom are saved in the same table
            const string roomType = "room_type";

            modelBuilder.Entity<Hotel>()
                .ToTable("hotel");

            modelBuilder.Entity<Room>()
                .ToTable("room");

            modelBuilder.Entity<SimpleRoom>()
                .HasDiscriminator<string>(roomType)
                .HasValue<SimpleRoom>(typeof(SimpleRoom).ToString());

            modelBuilder.Entity<VipRoom>()
                .HasDiscriminator<string>(roomType)
                .HasValue<VipRoom>(typeof(VipRoom).ToString());

            modelBuilder.Entity<Booking>()
                .ToTable("booking");
        }
    }
}
```
```sql
CREATE TABLE "hotel" (
    "Id" TEXT NOT NULL CONSTRAINT "PK_hotel" PRIMARY KEY,
    "Name" TEXT NOT NULL
);

CREATE TABLE "room" (
    "Id" TEXT NOT NULL CONSTRAINT "PK_room" PRIMARY KEY,
    "RoomNumber" INTEGER NOT NULL,
    "Capacity" INTEGER NOT NULL,
    "room_type" TEXT NOT NULL,
    "HotelId" TEXT NULL,
    "HasJacuzzi" INTEGER NULL,
    "VipRoom_HotelId" TEXT NULL,
    CONSTRAINT "FK_room_hotel_HotelId" FOREIGN KEY ("HotelId") REFERENCES "hotel" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_room_hotel_VipRoom_HotelId" FOREIGN KEY ("VipRoom_HotelId") REFERENCES "hotel" ("Id") ON DELETE CASCADE
);

CREATE TABLE "booking" (
    "Id" TEXT NOT NULL CONSTRAINT "PK_booking" PRIMARY KEY,
    "Date" TEXT NOT NULL,
    "Duration" INTEGER NOT NULL,
    "RoomId" TEXT NOT NULL,
    "HotelId" TEXT NOT NULL,
    CONSTRAINT "FK_booking_hotel_HotelId" FOREIGN KEY ("HotelId") REFERENCES "hotel" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_booking_room_RoomId" FOREIGN KEY ("RoomId") REFERENCES "room" ("Id") ON DELETE CASCADE
);

CREATE INDEX "IX_booking_HotelId" ON "booking" ("HotelId");
CREATE INDEX "IX_booking_RoomId" ON "booking" ("RoomId");
CREATE INDEX "IX_room_HotelId" ON "room" ("HotelId");
CREATE INDEX "IX_room_VipRoom_HotelId" ON "room" ("VipRoom_HotelId");

```

### DDD Domain Model
`Domain-Driven Design (DDD)` adds the crucial requirement that all invariants of Domain Models must always be in a valid state.

This means that if a `Domain Model` aggregate root object contains related collections, then when the object is loaded into memory, it should contain all those collections as well.

When `Domain Model` aggregate root object is saved into DB, it must be saved entirely in one transaction.

This means that a `DDD Domain Model` aggregate root object cannot have any direct references to other aggregate root objects. It can only reference them by their `IDs`.

"Therefore, it is crucial to carefully consider the domain area beforehand to prevent excessive data loading into memory. If performance issues arise due to excessive data loading, future refactoring may involve breaking down the aggregate root into smaller entities or even deviating from the `DDD pattern` by implementing `lazy loading` or replacing some parts of the system with a `Transaction Script` approach, for ex. for often update of the `Status`.

```csharp
public class Hotel : IAggregateRoot
    {
        public Guid Id { get; set; }

        // Inderect reference to another Aggregate Root
        public Guid OwnerId {get; set; }

        public string Name { get; set; }

        public int Status { get; set; }

        // If `Hotel` is loaded, all its collections loaded as well
        public virtual ICollection<Booking> Bookings { get; set; } = [];
    }

public class VipRoom : IAggregateRoot {} 

public class SimpleRoom : IAggregateRoot {} 

public class Booking : IEntity { } 

public class Owner : IAggregateRoot {} 
```