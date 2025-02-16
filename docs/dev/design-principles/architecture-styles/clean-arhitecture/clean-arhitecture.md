# Clean architecture

`Clean Architecture` is a software design philosophy and architectural pattern that emphasizes the separation of concerns and the independence of frameworks and tools. 

The goals of clean architecture are to make applications:

- Independent of third-party libraries and frameworks.
- Independent of databases and file systems.
- Independent of external services and agents.
- Easy to test business rules.

![clean arhitecture](images/clean-arhitecture.jpg)

### Layers

Clean architecture generally contains four main layers:

- Enterprise Business Rules layer
- Application Business Rules layer
- Interface Adapters layer
- Frameworks & Drivers

The architecture is flexible in terms of the number of layers, but the core principle is always the strict application of the `Dependency Rule`.

### Dependency Rule
Clean Architecture splits applications into `layers`, where inner layers represent `policies` and outer layers represent `mechanisms`.

`Policies` represent the core business rules, logic, and decisions of the application. They define what the system should do, independent of how it's done.   

Examples:
- Calculating taxes
- Determining customer eligibility for a discount
- Processing an order   
- Validating user input

`Mechanisms` refer to the technical details and implementation specifics of how the policies are carried out. They define how the system achieves the goals defined by the policies.

Examples:
- Database interactions (storing and retrieving data)
- User interface elements (how data is presented to the user)
- Communication with external services (APIs)
- Framework-specific implementations (using a particular library or framework)

##### Dependency Rule
The main rule that drives this architecture is the `Dependency Rule`.
> Dependencies in source code should be directed inward, towards high-level policies.

Inner layers must remain completely isolated from any details declared in outer layers.

No constant, class, function, or variable defined in the outer circle should be used within the inner circle.


#### Entities

Entities encapsulate enterprise-wide business rules. An entity can be an object with methods or a set of data structures and functions. The key is that these entities should be reusable across multiple applications within the enterprise.

Example

<hidden style="display:none">
@startuml

interface IEntity
interface IAggregateRootEntity

IEntity <|-- IAggregateRootEntity

class CustomerEntity {
  Guid id 
  Address address 
  string firstName 
  string secondName 

  void ChangeName(string firstName, string secondName)
  void UpdateCustomerAddress(Address address)
}
IAggregateRootEntity <|-- CustomerEntity

class Address {
  string country
  string city
  string address

  Address(string country, string city, string address)
}

CustomerEntity *-- Address

class OrderEntity
{
  Guid id
  Guid custromerId
  IReadOnlyList<Guid> ProductIds
  decimal totalPrice 
  Discount discount

  void MakeDicount(decimal discount)
  void AddProduct(Guid productId) 
}

IAggregateRootEntity <|-- OrderEntity

class DiscountEntity{
  Guid id
  decimal discount
  void MakeDicount(decimal discount)
}

IEntity <|-- DiscountEntity
OrderEntity *-- DiscountEntity

class ProductEntity{
  id: Guid
  name: string 
  price: decimal

  void ChangePrice(decimal price)
}

IAggregateRootEntity <|-- ProductEntity

@enduml
</hidden>



<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" data-diagram-type="CLASS" height="565px" preserveAspectRatio="none" style="width:1054px;height:565px;background:#FFFFFF;" version="1.1" viewBox="0 0 1054 565" width="1054px" zoomAndPan="magnify"><defs/><g><!--class IEntity--><g id="elem_IEntity"><rect codeLine="1" fill="#F1F1F1" height="48" id="IEntity" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="77.001" x="778.49" y="7"/><ellipse cx="793.49" cy="23" fill="#B4A7E5" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M789.4119,18.7656 L789.4119,16.6094 L796.8025,16.6094 L796.8025,18.7656 L794.3338,18.7656 L794.3338,26.8438 L796.8025,26.8438 L796.8025,29 L789.4119,29 L789.4119,26.8438 L791.8806,26.8438 L791.8806,18.7656 L789.4119,18.7656 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" font-style="italic" lengthAdjust="spacing" textLength="45.001" x="807.49" y="27.8467">IEntity</text><line style="stroke:#181818;stroke-width:0.5;" x1="779.49" x2="854.491" y1="39" y2="39"/><line style="stroke:#181818;stroke-width:0.5;" x1="779.49" x2="854.491" y1="47" y2="47"/></g><!--class IAggregateRootEntity--><g id="elem_IAggregateRootEntity"><rect codeLine="2" fill="#F1F1F1" height="48" id="IAggregateRootEntity" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="182.6367" x="639.67" y="115"/><ellipse cx="654.67" cy="131" fill="#B4A7E5" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M650.5919,126.7656 L650.5919,124.6094 L657.9825,124.6094 L657.9825,126.7656 L655.5138,126.7656 L655.5138,134.8438 L657.9825,134.8438 L657.9825,137 L650.5919,137 L650.5919,134.8438 L653.0606,134.8438 L653.0606,126.7656 L650.5919,126.7656 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" font-style="italic" lengthAdjust="spacing" textLength="150.6367" x="668.67" y="135.8467">IAggregateRootEntity</text><line style="stroke:#181818;stroke-width:0.5;" x1="640.67" x2="821.3067" y1="147" y2="147"/><line style="stroke:#181818;stroke-width:0.5;" x1="640.67" x2="821.3067" y1="155" y2="155"/></g><!--class CustomerEntity--><g id="elem_CustomerEntity"><rect codeLine="6" fill="#F1F1F1" height="145.7813" id="CustomerEntity" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="409.9746" x="7" y="231.15"/><ellipse cx="153.2993" cy="247.15" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M156.2681,252.7906 Q155.6899,253.0875 155.0493,253.2281 Q154.4087,253.3844 153.7056,253.3844 Q151.2056,253.3844 149.8774,251.7437 Q148.5649,250.0875 148.5649,246.9625 Q148.5649,243.8375 149.8774,242.1812 Q151.2056,240.525 153.7056,240.525 Q154.4087,240.525 155.0493,240.6812 Q155.7056,240.8375 156.2681,241.1344 L156.2681,243.8531 Q155.6431,243.275 155.0493,243.0094 Q154.4556,242.7281 153.8306,242.7281 Q152.4868,242.7281 151.7993,243.8062 Q151.1118,244.8687 151.1118,246.9625 Q151.1118,249.0562 151.7993,250.1344 Q152.4868,251.1969 153.8306,251.1969 Q154.4556,251.1969 155.0493,250.9312 Q155.6431,250.65 156.2681,250.0719 L156.2681,252.7906 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="108.876" x="173.7993" y="251.9967">CustomerEntity</text><line style="stroke:#181818;stroke-width:0.5;" x1="8" x2="415.9746" y1="263.15" y2="263.15"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="49.7246" x="13" y="280.1451">Guid id</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="116.0674" x="13" y="296.442">Address address</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="113.2988" x="13" y="312.7389">string firstName</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="135.8711" x="13" y="329.0357">string secondName</text><line style="stroke:#181818;stroke-width:0.5;" x1="8" x2="415.9746" y1="336.3375" y2="336.3375"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="397.9746" x="13" y="353.3326">void ChangeName(string firstName, string secondName)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="336.082" x="13" y="369.6295">void UpdateCustomerAddress(Address address)</text></g><!--class Address--><g id="elem_Address"><rect codeLine="17" fill="#F1F1F1" height="113.1875" id="Address" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="365.1582" x="29.41" y="445.08"/><ellipse cx="179.5853" cy="461.08" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M182.554,466.7206 Q181.9759,467.0175 181.3353,467.1581 Q180.6947,467.3144 179.9915,467.3144 Q177.4915,467.3144 176.1634,465.6738 Q174.8509,464.0175 174.8509,460.8925 Q174.8509,457.7675 176.1634,456.1113 Q177.4915,454.455 179.9915,454.455 Q180.6947,454.455 181.3353,454.6113 Q181.9915,454.7675 182.554,455.0644 L182.554,457.7831 Q181.929,457.205 181.3353,456.9394 Q180.7415,456.6581 180.1165,456.6581 Q178.7728,456.6581 178.0853,457.7363 Q177.3978,458.7988 177.3978,460.8925 Q177.3978,462.9863 178.0853,464.0644 Q178.7728,465.1269 180.1165,465.1269 Q180.7415,465.1269 181.3353,464.8613 Q181.929,464.58 182.554,464.0019 L182.554,466.7206 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="56.3076" x="200.0853" y="465.9267">Address</text><line style="stroke:#181818;stroke-width:0.5;" x1="30.41" x2="393.5682" y1="477.08" y2="477.08"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="98.1777" x="35.41" y="494.0751">string country</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="70" x="35.41" y="510.372">string city</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="99.9482" x="35.41" y="526.6689">string address</text><line style="stroke:#181818;stroke-width:0.5;" x1="30.41" x2="393.5682" y1="533.9706" y2="533.9706"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="353.1582" x="35.41" y="550.9657">Address(string country, string city, string address)</text></g><!--class OrderEntity--><g id="elem_OrderEntity"><rect codeLine="27" fill="#F1F1F1" height="162.0781" id="OrderEntity" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="267.7598" x="452.11" y="223"/><ellipse cx="541.2882" cy="239" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M544.257,244.6406 Q543.6788,244.9375 543.0382,245.0781 Q542.3976,245.2344 541.6945,245.2344 Q539.1945,245.2344 537.8663,243.5938 Q536.5538,241.9375 536.5538,238.8125 Q536.5538,235.6875 537.8663,234.0313 Q539.1945,232.375 541.6945,232.375 Q542.3976,232.375 543.0382,232.5313 Q543.6945,232.6875 544.257,232.9844 L544.257,235.7031 Q543.632,235.125 543.0382,234.8594 Q542.4445,234.5781 541.8195,234.5781 Q540.4757,234.5781 539.7882,235.6563 Q539.1007,236.7188 539.1007,238.8125 Q539.1007,240.9063 539.7882,241.9844 Q540.4757,243.0469 541.8195,243.0469 Q542.4445,243.0469 543.0382,242.7813 Q543.632,242.5 544.257,241.9219 L544.257,244.6406 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="80.9033" x="561.7882" y="243.8467">OrderEntity</text><line style="stroke:#181818;stroke-width:0.5;" x1="453.11" x2="718.8698" y1="255" y2="255"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="49.7246" x="458.11" y="271.9951">Guid id</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="121.6455" x="458.11" y="288.292">Guid custromerId</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="230.9043" x="458.11" y="304.5889">IReadOnlyList&lt;Guid&gt; ProductIds</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="126.0547" x="458.11" y="320.8857">decimal totalPrice</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="125.4805" x="458.11" y="337.1826">Discount discount</text><line style="stroke:#181818;stroke-width:0.5;" x1="453.11" x2="718.8698" y1="344.4844" y2="344.4844"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="255.7598" x="458.11" y="361.4795">void MakeDicount(decimal discount)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="230.1797" x="458.11" y="377.7764">void AddProduct(Guid productId)</text></g><!--class DiscountEntity--><g id="elem_DiscountEntity"><rect codeLine="41" fill="#F1F1F1" height="96.8906" id="DiscountEntity" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="267.7598" x="683.11" y="453.23"/><ellipse cx="761.5729" cy="469.23" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M764.5416,474.8706 Q763.9635,475.1675 763.3229,475.3081 Q762.6823,475.4644 761.9791,475.4644 Q759.4791,475.4644 758.151,473.8237 Q756.8385,472.1675 756.8385,469.0425 Q756.8385,465.9175 758.151,464.2612 Q759.4791,462.605 761.9791,462.605 Q762.6823,462.605 763.3229,462.7612 Q763.9791,462.9175 764.5416,463.2144 L764.5416,465.9331 Q763.9166,465.355 763.3229,465.0894 Q762.7291,464.8081 762.1041,464.8081 Q760.7604,464.8081 760.0729,465.8862 Q759.3854,466.9487 759.3854,469.0425 Q759.3854,471.1362 760.0729,472.2144 Q760.7604,473.2769 762.1041,473.2769 Q762.7291,473.2769 763.3229,473.0112 Q763.9166,472.73 764.5416,472.1519 L764.5416,474.8706 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="102.334" x="782.0729" y="474.0767">DiscountEntity</text><line style="stroke:#181818;stroke-width:0.5;" x1="684.11" x2="949.8698" y1="485.23" y2="485.23"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="49.7246" x="689.11" y="502.2251">Guid id</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="119.2119" x="689.11" y="518.522">decimal discount</text><line style="stroke:#181818;stroke-width:0.5;" x1="684.11" x2="949.8698" y1="525.8238" y2="525.8238"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="255.7598" x="689.11" y="542.8189">void MakeDicount(decimal discount)</text></g><!--class ProductEntity--><g id="elem_ProductEntity"><rect codeLine="50" fill="#F1F1F1" height="113.1875" id="ProductEntity" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="239.4863" x="755.24" y="247.45"/><ellipse cx="823.4421" cy="263.45" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M826.4109,269.0906 Q825.8328,269.3875 825.1921,269.5281 Q824.5515,269.6844 823.8484,269.6844 Q821.3484,269.6844 820.0203,268.0438 Q818.7078,266.3875 818.7078,263.2625 Q818.7078,260.1375 820.0203,258.4813 Q821.3484,256.825 823.8484,256.825 Q824.5515,256.825 825.1921,256.9813 Q825.8484,257.1375 826.4109,257.4344 L826.4109,260.1531 Q825.7859,259.575 825.1921,259.3094 Q824.5984,259.0281 823.9734,259.0281 Q822.6296,259.0281 821.9421,260.1063 Q821.2546,261.1688 821.2546,263.2625 Q821.2546,265.3563 821.9421,266.4344 Q822.6296,267.4969 823.9734,267.4969 Q824.5984,267.4969 825.1921,267.2313 Q825.7859,266.95 826.4109,266.3719 L826.4109,269.0906 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="94.582" x="843.9421" y="268.2967">ProductEntity</text><line style="stroke:#181818;stroke-width:0.5;" x1="756.24" x2="993.7263" y1="279.45" y2="279.45"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="54.4414" x="761.24" y="296.4451">id: Guid</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="89.0586" x="761.24" y="312.742">name: string</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="99.2031" x="761.24" y="329.0389">price: decimal</text><line style="stroke:#181818;stroke-width:0.5;" x1="756.24" x2="993.7263" y1="336.3406" y2="336.3406"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="227.4863" x="761.24" y="353.3357">void ChangePrice(decimal price)</text></g><!--reverse link IEntity to IAggregateRootEntity--><g id="link_IEntity_IAggregateRootEntity"><path codeLine="4" d="M786.7721,69.2505 C772.4421,86.9205 764.14,97.14 749.82,114.8 " fill="none" id="IEntity-backto-IAggregateRootEntity" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="798.11,55.27,782.112,65.4712,791.4323,73.0297,798.11,55.27" style="stroke:#181818;stroke-width:1;"/></g><!--reverse link IAggregateRootEntity to CustomerEntity--><g id="link_IAggregateRootEntity_CustomerEntity"><path codeLine="15" d="M623.7333,168.0787 C564.8033,183.8687 503.63,201.09 434.99,223 C427.25,225.47 419.38,228.04 411.44,230.67 " fill="none" id="IAggregateRootEntity-backto-CustomerEntity" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="641.12,163.42,622.1804,162.2831,625.2862,173.8742,641.12,163.42" style="stroke:#181818;stroke-width:1;"/></g><!--reverse link CustomerEntity to Address--><g id="link_CustomerEntity_Address"><path codeLine="25" d="M211.99,389.33 C211.99,411.65 211.99,423.87 211.99,444.89 " fill="none" id="CustomerEntity-backto-Address" style="stroke:#181818;stroke-width:1;"/><polygon fill="#181818" points="211.99,377.33,207.99,383.33,211.99,389.33,215.99,383.33,211.99,377.33" style="stroke:#181818;stroke-width:1;"/></g><!--reverse link IAggregateRootEntity to OrderEntity--><g id="link_IAggregateRootEntity_OrderEntity"><path codeLine="39" d="M698.2509,176.8129 C684.2409,192.5729 676.8,200.94 657.49,222.65 " fill="none" id="IAggregateRootEntity-backto-OrderEntity" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="710.21,163.36,693.7666,172.8265,702.7352,180.7993,710.21,163.36" style="stroke:#181818;stroke-width:1;"/></g><!--reverse link IEntity to DiscountEntity--><g id="link_IEntity_DiscountEntity"><path codeLine="47" d="M870.1552,65.3521 C917.3252,96.7421 980.22,147.43 1011.99,223 C1039.9,289.41 1047.65,322.49 1011.99,385.08 C995.72,413.64 969.32,435.86 941.13,452.85 " fill="none" id="IEntity-backto-DiscountEntity" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="855.17,55.38,866.8312,70.3472,873.4793,60.3571,855.17,55.38" style="stroke:#181818;stroke-width:1;"/></g><!--reverse link OrderEntity to DiscountEntity--><g id="link_OrderEntity_DiscountEntity"><path codeLine="48" d="M690.0981,393.2143 C717.1081,416.0843 736.5,432.51 760.44,452.78 " fill="none" id="OrderEntity-backto-DiscountEntity" style="stroke:#181818;stroke-width:1;"/><polygon fill="#181818" points="680.94,385.46,682.9342,392.3899,690.0981,393.2143,688.1038,386.2845,680.94,385.46" style="stroke:#181818;stroke-width:1;"/></g><!--reverse link IAggregateRootEntity to ProductEntity--><g id="link_IAggregateRootEntity_ProductEntity"><path codeLine="58" d="M763.5358,176.8513 C782.7458,198.6013 800.21,218.38 825.49,247 " fill="none" id="IAggregateRootEntity-backto-ProductEntity" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="751.62,163.36,759.0387,180.8232,768.0328,172.8794,751.62,163.36" style="stroke:#181818;stroke-width:1;"/></g><!--SRC=[ZPBTQiCm38Nl_HI-J4Rx0gKCIZj6O5jBOGzWR3SpJUrYAuFIzTqdEtP-l7KC0d5EZgHFafK6QG-CIrezQL1m8MfGLdLjPSr0xes1-9j47rr-pUTtBBnXpj5rwy2Sf8t-Aw7qkLM2ueF7bH1Meel5DqeEhD8rFIZhu8sTv4XpaXijEX7LJuD9rXzCrz9hHHuv-nbNfh3tiq3S11SnYWod93VoMszTrzFEKhyfnNN0vgRLO2yZmVlxhrYC3ECefe6pSTmi2_EC91lo0zAjKjOEQsj5JphQGJfnJ61zXifBrLuoiTNDvKKvM7h38zrP8reEbN1e49Ah4sie663DpYeUjhHHBX1J4G_zabxPKMvKq8eKcqpzIf0u5Ya2qpbLBAdlyVuYnht5TXDAfquRpW7-1tdBxloq0XanXF5dloDMx6-WKc8HoF2eyNekqdBn- -p7kaYqsNqFC-yfWxNyUqYJqjy0]--></g></svg>


#### Use Cases

This layer houses the *application-specific logic*. It organizes the flow of data into the Entities. After the Entities apply business rules on the data within the Entities layer, the Use Case layer passes out the handled data to the outer layer.

Any changes in `Application Business Rules layer` will not affect code in `Enterprise Business Rules layer`.

At the same time, the `Application Business Rules layer` knows nothing about outer layers. <br>
This layer operates on interfaces, whose implementations reside in other layers.<br>
It doesn't know about how the `ImageService` saves images or how the `AppDbContext` saves data in the database.


Example

<hidden style="display:none">
@startuml

interface IAppDbContext{
    IRepository<Cusomer> Customers {get; set;}
    IRepository<Order> Orders {get; set;}
    IRepository<Product> Products {get; set;}
}

interface IImageService{
    byte[] LoadImage(Guid imageId)
}


package CustomerUseCases{

  class CustomerOrderDto {
    Guid customerId
    decimal totalPrice 
  }
  interface ICustomerService{
   Guid AddCustomer(string firstName, string secondName)
   void UpdateCustomerAddress(Guid customerId, string country, string city, string address)
 }

  class CustomerService{
   IAppDbContext cotext

   CustomerService(IAppDbContext cotext)
   Guid AddCustomer(string firstName, string secondName)
   void UpdateCustomerAddress(Guid customerId, string country, string city, string address)
  }

  ICustomerService <|-- CustomerService
  CustomerOrderDto .. CustomerService
}

package ProductUseCases{ 
 class ProductDto {
  Guid productId
  string name
 }

 interface IProductService{
   Task<Guid> AddProduct(string name, decimal price)
   Task<ProductDto> ListProducts(int skip, int top)
 }

 class ProductService{
   IAppDbContext cotext
   IImageService imageService

   ProductService(IAppDbContext cotext, IImageService imageService)    
   Task<Guid> AddProduct(string name, decimal price)
   Task<ProductDto> ListProducts(int skip, int top)
 }

 IProductService <|-- ProductService
 ProductDto .. ProductService 
}

IAppDbContext .down. CustomerService
IAppDbContext .down. ProductService
IImageService .down. ProductService

@enduml
</hidden>

<div style="overflow-y: auto">

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" data-diagram-type="CLASS" height="342px" preserveAspectRatio="none" style="width:2090px;height:342px;background:#FFFFFF;" version="1.1" viewBox="0 0 2090 342" width="2090px" zoomAndPan="magnify"><defs/><g><!--cluster CustomerUseCases--><g id="cluster_CustomerUseCases"><path d="M8.5,6 L160.4512,6 A3.75,3.75 0 0 1 162.9512,8.5 L169.9512,28.2969 L877.5,28.2969 A2.5,2.5 0 0 1 880,30.7969 L880,324.58 A2.5,2.5 0 0 1 877.5,327.08 L8.5,327.08 A2.5,2.5 0 0 1 6,324.58 L6,8.5 A2.5,2.5 0 0 1 8.5,6 " fill="none" style="stroke:#000000;stroke-width:1.5;"/><line style="stroke:#000000;stroke-width:1.5;" x1="6" x2="169.9512" y1="28.2969" y2="28.2969"/><text fill="#000000" font-family="sans-serif" font-size="14" font-weight="bold" lengthAdjust="spacing" textLength="150.9512" x="10" y="20.9951">CustomerUseCases</text></g><!--cluster ProductUseCases--><g id="cluster_ProductUseCases"><path d="M1258.5,6 L1396.3418,6 A3.75,3.75 0 0 1 1398.8418,8.5 L1405.8418,28.2969 L1820.5,28.2969 A2.5,2.5 0 0 1 1823,30.7969 L1823,332.73 A2.5,2.5 0 0 1 1820.5,335.23 L1258.5,335.23 A2.5,2.5 0 0 1 1256,332.73 L1256,8.5 A2.5,2.5 0 0 1 1258.5,6 " fill="none" style="stroke:#000000;stroke-width:1.5;"/><line style="stroke:#000000;stroke-width:1.5;" x1="1256" x2="1405.8418" y1="28.2969" y2="28.2969"/><text fill="#000000" font-family="sans-serif" font-size="14" font-weight="bold" lengthAdjust="spacing" textLength="136.8418" x="1260" y="20.9951">ProductUseCases</text></g><!--class CustomerOrderDto--><g id="elem_CustomerOrderDto"><rect codeLine="14" fill="#F1F1F1" height="80.5938" id="CustomerOrderDto" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="164.8701" x="21.56" y="41"/><ellipse cx="36.56" cy="57" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M39.5288,62.6406 Q38.9506,62.9375 38.31,63.0781 Q37.6694,63.2344 36.9663,63.2344 Q34.4663,63.2344 33.1381,61.5938 Q31.8256,59.9375 31.8256,56.8125 Q31.8256,53.6875 33.1381,52.0313 Q34.4663,50.375 36.9663,50.375 Q37.6694,50.375 38.31,50.5313 Q38.9663,50.6875 39.5288,50.9844 L39.5288,53.7031 Q38.9038,53.125 38.31,52.8594 Q37.7163,52.5781 37.0913,52.5781 Q35.7475,52.5781 35.06,53.6563 Q34.3725,54.7188 34.3725,56.8125 Q34.3725,58.9063 35.06,59.9844 Q35.7475,61.0469 37.0913,61.0469 Q37.7163,61.0469 38.31,60.7813 Q38.9038,60.5 39.5288,59.9219 L39.5288,62.6406 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="132.8701" x="50.56" y="61.8467">CustomerOrderDto</text><line style="stroke:#181818;stroke-width:0.5;" x1="22.56" x2="185.4301" y1="73" y2="73"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="115.8896" x="27.56" y="89.9951">Guid customerId</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="126.0547" x="27.56" y="106.292">decimal totalPrice</text><line style="stroke:#181818;stroke-width:0.5;" x1="22.56" x2="185.4301" y1="113.5938" y2="113.5938"/></g><!--class ICustomerService--><g id="elem_ICustomerService"><rect codeLine="18" fill="#F1F1F1" height="80.5938" id="ICustomerService" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="642.7314" x="221.63" y="41"/><ellipse cx="476.8087" cy="57" fill="#B4A7E5" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M472.7306,52.7656 L472.7306,50.6094 L480.1212,50.6094 L480.1212,52.7656 L477.6525,52.7656 L477.6525,60.8438 L480.1212,60.8438 L480.1212,63 L472.7306,63 L472.7306,60.8438 L475.1993,60.8438 L475.1993,52.7656 L472.7306,52.7656 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" font-style="italic" lengthAdjust="spacing" textLength="123.874" x="497.3087" y="61.8467">ICustomerService</text><line style="stroke:#181818;stroke-width:0.5;" x1="222.63" x2="863.3614" y1="73" y2="73"/><line style="stroke:#181818;stroke-width:0.5;" x1="222.63" x2="863.3614" y1="81" y2="81"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="401.2969" x="227.63" y="97.9951">Guid AddCustomer(string firstName, string secondName)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="630.7314" x="227.63" y="114.292">void UpdateCustomerAddress(Guid customerId, string country, string city, string address)</text></g><!--class CustomerService--><g id="elem_CustomerService"><rect codeLine="23" fill="#F1F1F1" height="113.1875" id="CustomerService" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="642.7314" x="221.63" y="197.89"/><ellipse cx="478.8732" cy="213.89" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M481.8419,219.5306 Q481.2638,219.8275 480.6232,219.9681 Q479.9825,220.1244 479.2794,220.1244 Q476.7794,220.1244 475.4513,218.4838 Q474.1388,216.8275 474.1388,213.7025 Q474.1388,210.5775 475.4513,208.9213 Q476.7794,207.265 479.2794,207.265 Q479.9825,207.265 480.6232,207.4213 Q481.2794,207.5775 481.8419,207.8744 L481.8419,210.5931 Q481.2169,210.015 480.6232,209.7494 Q480.0294,209.4681 479.4044,209.4681 Q478.0607,209.4681 477.3732,210.5463 Q476.6857,211.6088 476.6857,213.7025 Q476.6857,215.7963 477.3732,216.8744 Q478.0607,217.9369 479.4044,217.9369 Q480.0294,217.9369 480.6232,217.6713 Q481.2169,217.39 481.8419,216.8119 L481.8419,219.5306 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="119.7451" x="499.3732" y="218.7367">CustomerService</text><line style="stroke:#181818;stroke-width:0.5;" x1="222.63" x2="863.3614" y1="229.89" y2="229.89"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="154.8271" x="227.63" y="246.8851">IAppDbContext cotext</text><line style="stroke:#181818;stroke-width:0.5;" x1="222.63" x2="863.3614" y1="254.1869" y2="254.1869"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="285.4961" x="227.63" y="271.182">CustomerService(IAppDbContext cotext)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="401.2969" x="227.63" y="287.4789">Guid AddCustomer(string firstName, string secondName)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="630.7314" x="227.63" y="303.7757">void UpdateCustomerAddress(Guid customerId, string country, string city, string address)</text></g><!--class ProductDto--><g id="elem_ProductDto"><rect codeLine="36" fill="#F1F1F1" height="80.5938" id="ProductDto" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="116.1182" x="1271.94" y="41"/><ellipse cx="1289.448" cy="57" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M1292.4167,62.6406 Q1291.8386,62.9375 1291.198,63.0781 Q1290.5573,63.2344 1289.8542,63.2344 Q1287.3542,63.2344 1286.0261,61.5938 Q1284.7136,59.9375 1284.7136,56.8125 Q1284.7136,53.6875 1286.0261,52.0313 Q1287.3542,50.375 1289.8542,50.375 Q1290.5573,50.375 1291.198,50.5313 Q1291.8542,50.6875 1292.4167,50.9844 L1292.4167,53.7031 Q1291.7917,53.125 1291.198,52.8594 Q1290.6042,52.5781 1289.9792,52.5781 Q1288.6355,52.5781 1287.948,53.6563 Q1287.2605,54.7188 1287.2605,56.8125 Q1287.2605,58.9063 1287.948,59.9844 Q1288.6355,61.0469 1289.9792,61.0469 Q1290.6042,61.0469 1291.198,60.7813 Q1291.7917,60.5 1292.4167,59.9219 L1292.4167,62.6406 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="78.5449" x="1304.0053" y="61.8467">ProductDto</text><line style="stroke:#181818;stroke-width:0.5;" x1="1272.94" x2="1387.0582" y1="73" y2="73"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="104.1182" x="1277.94" y="89.9951">Guid productId</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="84.3418" x="1277.94" y="106.292">string name</text><line style="stroke:#181818;stroke-width:0.5;" x1="1272.94" x2="1387.0582" y1="113.5938" y2="113.5938"/></g><!--class IProductService--><g id="elem_IProductService"><rect codeLine="41" fill="#F1F1F1" height="80.5938" id="IProductService" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="384.6543" x="1422.67" y="41"/><ellipse cx="1555.9571" cy="57" fill="#B4A7E5" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M1551.879,52.7656 L1551.879,50.6094 L1559.2696,50.6094 L1559.2696,52.7656 L1556.8009,52.7656 L1556.8009,60.8438 L1559.2696,60.8438 L1559.2696,63 L1551.879,63 L1551.879,60.8438 L1554.3477,60.8438 L1554.3477,52.7656 L1551.879,52.7656 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" font-style="italic" lengthAdjust="spacing" textLength="109.5801" x="1576.4571" y="61.8467">IProductService</text><line style="stroke:#181818;stroke-width:0.5;" x1="1423.67" x2="1806.3243" y1="73" y2="73"/><line style="stroke:#181818;stroke-width:0.5;" x1="1423.67" x2="1806.3243" y1="81" y2="81"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="372.6543" x="1428.67" y="97.9951">Task&lt;Guid&gt; AddProduct(string name, decimal price)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="340.8125" x="1428.67" y="114.292">Task&lt;ProductDto&gt; ListProducts(int skip, int top)</text></g><!--class ProductService--><g id="elem_ProductService"><rect codeLine="46" fill="#F1F1F1" height="129.4844" id="ProductService" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="491.6162" x="1293.19" y="189.75"/><ellipse cx="1482.0225" cy="205.75" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M1484.9913,211.3906 Q1484.4131,211.6875 1483.7725,211.8281 Q1483.1319,211.9844 1482.4288,211.9844 Q1479.9288,211.9844 1478.6006,210.3438 Q1477.2881,208.6875 1477.2881,205.5625 Q1477.2881,202.4375 1478.6006,200.7813 Q1479.9288,199.125 1482.4288,199.125 Q1483.1319,199.125 1483.7725,199.2813 Q1484.4288,199.4375 1484.9913,199.7344 L1484.9913,202.4531 Q1484.3663,201.875 1483.7725,201.6094 Q1483.1788,201.3281 1482.5538,201.3281 Q1481.21,201.3281 1480.5225,202.4063 Q1479.835,203.4688 1479.835,205.5625 Q1479.835,207.6563 1480.5225,208.7344 Q1481.21,209.7969 1482.5538,209.7969 Q1483.1788,209.7969 1483.7725,209.5313 Q1484.3663,209.25 1484.9913,208.6719 L1484.9913,211.3906 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="105.4512" x="1502.5225" y="210.5967">ProductService</text><line style="stroke:#181818;stroke-width:0.5;" x1="1294.19" x2="1783.8062" y1="221.75" y2="221.75"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="154.8271" x="1299.19" y="238.7451">IAppDbContext cotext</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="199.5137" x="1299.19" y="255.042">IImageService imageService</text><line style="stroke:#181818;stroke-width:0.5;" x1="1294.19" x2="1783.8062" y1="262.3438" y2="262.3438"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="479.6162" x="1299.19" y="279.3389">ProductService(IAppDbContext cotext, IImageService imageService)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="372.6543" x="1299.19" y="295.6357">Task&lt;Guid&gt; AddProduct(string name, decimal price)</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="340.8125" x="1299.19" y="311.9326">Task&lt;ProductDto&gt; ListProducts(int skip, int top)</text></g><!--class IAppDbContext--><g id="elem_IAppDbContext"><rect codeLine="1" fill="#F1F1F1" height="96.8906" id="IAppDbContext" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="337.459" x="899.27" y="32.86"/><ellipse cx="1010.6308" cy="48.86" fill="#B4A7E5" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M1006.5527,44.6256 L1006.5527,42.4694 L1013.9433,42.4694 L1013.9433,44.6256 L1011.4746,44.6256 L1011.4746,52.7038 L1013.9433,52.7038 L1013.9433,54.86 L1006.5527,54.86 L1006.5527,52.7038 L1009.0215,52.7038 L1009.0215,44.6256 L1006.5527,44.6256 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" font-style="italic" lengthAdjust="spacing" textLength="106.2373" x="1031.1308" y="53.7067">IAppDbContext</text><line style="stroke:#181818;stroke-width:0.5;" x1="900.27" x2="1235.729" y1="64.86" y2="64.86"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="325.459" x="905.27" y="81.8551">IRepository&lt;Cusomer&gt; Customers {get; set;}</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="275.0029" x="905.27" y="98.152">IRepository&lt;Order&gt; Orders {get; set;}</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="302.3604" x="905.27" y="114.4489">IRepository&lt;Product&gt; Products {get; set;}</text><line style="stroke:#181818;stroke-width:0.5;" x1="900.27" x2="1235.729" y1="121.7506" y2="121.7506"/></g><!--class IImageService--><g id="elem_IImageService"><rect codeLine="7" fill="#F1F1F1" height="64.2969" id="IImageService" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="240.8193" x="1842.59" y="49.15"/><ellipse cx="1908.8918" cy="65.15" fill="#B4A7E5" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M1904.8136,60.9156 L1904.8136,58.7594 L1912.2043,58.7594 L1912.2043,60.9156 L1909.7355,60.9156 L1909.7355,68.9938 L1912.2043,68.9938 L1912.2043,71.15 L1904.8136,71.15 L1904.8136,68.9938 L1907.2824,68.9938 L1907.2824,60.9156 L1904.8136,60.9156 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" font-style="italic" lengthAdjust="spacing" textLength="99.7158" x="1929.3918" y="69.9967">IImageService</text><line style="stroke:#181818;stroke-width:0.5;" x1="1843.59" x2="2082.4093" y1="81.15" y2="81.15"/><line style="stroke:#181818;stroke-width:0.5;" x1="1843.59" x2="2082.4093" y1="89.15" y2="89.15"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="228.8193" x="1848.59" y="106.1451">byte[] LoadImage(Guid imageId)</text></g><!--reverse link ICustomerService to CustomerService--><g id="link_ICustomerService_CustomerService"><path codeLine="31" d="M543,140 C543,162.43 543,172.81 543,197.46 " fill="none" id="ICustomerService-backto-CustomerService" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="543,122,537,140,549,140,543,122" style="stroke:#181818;stroke-width:1;"/></g><!--link CustomerOrderDto to CustomerService--><g id="link_CustomerOrderDto_CustomerService"><path codeLine="32" d="M186.13,122.01 C192.15,124.69 198.15,127.3 204,129.75 C260.78,153.52 323.91,177.27 380.15,197.52 " fill="none" id="CustomerOrderDto-CustomerService" style="stroke:#181818;stroke-width:1;stroke-dasharray:7.0,7.0;"/></g><!--reverse link IProductService to ProductService--><g id="link_IProductService_ProductService"><path codeLine="55" d="M1590.0671,138.452 C1581.1671,158.502 1577.45,166.88 1567.39,189.53 " fill="none" id="IProductService-backto-ProductService" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="1597.37,122,1584.5831,136.0177,1595.5511,140.8863,1597.37,122" style="stroke:#181818;stroke-width:1;"/></g><!--link ProductDto to ProductService--><g id="link_ProductDto_ProductService"><path codeLine="56" d="M1378.47,122 C1402.95,142.05 1433.26,166.88 1460.92,189.53 " fill="none" id="ProductDto-ProductService" style="stroke:#181818;stroke-width:1;stroke-dasharray:7.0,7.0;"/></g><!--link IAppDbContext to CustomerService--><g id="link_IAppDbContext_CustomerService"><path codeLine="59" d="M921.06,130.21 C857.05,151.08 781.6,175.69 714.99,197.41 " fill="none" id="IAppDbContext-CustomerService" style="stroke:#181818;stroke-width:1;stroke-dasharray:7.0,7.0;"/></g><!--link IAppDbContext to ProductService--><g id="link_IAppDbContext_ProductService"><path codeLine="60" d="M1199.83,130.21 C1250.17,148.51 1308.42,169.68 1362.28,189.26 " fill="none" id="IAppDbContext-ProductService" style="stroke:#181818;stroke-width:1;stroke-dasharray:7.0,7.0;"/></g><!--link IImageService to ProductService--><g id="link_IImageService_ProductService"><path codeLine="61" d="M1884.74,113.9 C1832.45,135.01 1761.83,163.52 1698.04,189.28 " fill="none" id="IImageService-ProductService" style="stroke:#181818;stroke-width:1;stroke-dasharray:7.0,7.0;"/></g><!--SRC=[pLFBQYin3DtFLsWv0sb-e25GKYW3fIrzh2vTkBORJ9AniPos8Ss_NsdiUOVUtQLPP6pfwFX8FZPLqFvTI0tbbNFNRojBWQzmp81-vQDs5asm_h1OxT7kj5y2BGAl48vh7Iu1wUyqWTzxnU3wypFomLkrbs49QJ54dxBCT1BBdLZh9-q_ZDHHujiXw3-lS6k5gfFvpTueCBmiLS7bcHDoGzjM-0lgbK2DnumOv5OWjgbQxdMm4CbhBfbofQfZIajYtqAmGMmVF0a1YdDRFPqDNrzgJNQbL9FBCNXJhU7TU0ntOgTda2AefQqKXmek_B1K-EAK2Bgf9Hgl4VEHm9P1sdqL_A7Rcz1jH2mcxjDq0dt50qSG9t-uOWpEpm6BNzfpR7fyGx3ulhWOzvN1r1Zp-GHrwYoMBDmwZAmHnviIZRNg7boCrRvACYlgFrvBpqofjdyppm8t2oPPydGJ8E-Hp5gVEhPeqHPrGfPmQp0qZowd0m4tnituQ7AtI_uOwF-dEpZUVwJn9JQJulIGwQnrPZzm5Fm6__C8HZSGlJACPVqR9e-CAjWZmqxdodvMKo-T1OsE6WxdBEOl]--></g></svg>

</div>


### Interface Adapters

The `Interface Adapters layer` acts as a bridge between external resources (like the Web or a Database) and the `Application Business Rules layer`, converting data into a format that the `Application Business Rules layer` can understand.<br>
For the `Web`: This layer can contain code related to the MVC pattern, including controllers, views, and models.<br>
For the `Database`: This layer can contain code that loads data from the Database.<br>
For the `external service`: This layer can contain code that interacts with services from other web applications.

Example

<hidden style="display:none">
@startuml

package MSSqlDatabase{

  class AppDbContext{
    IRepository<Cusomer> Customers {get; set;}
    IRepository<Order> Orders {get; set;}
    IRepository<Product> Products {get; set;}
  }
}

package ExternalWebServices{
  class ImageService{
    byte[] LoadImage(Guid imageId)
  }
}

package MVC{
  class UpdateCustomerAddressView{
  <html>@city</html>
  ...
  }

  class UpdateCustomerAddressViewModel{
    Guid customerId
    string country 
    string city
    string address
  }
  class CustomerController{
    Task<IActionResult> ChangeFirstName([FromBody]UpdateCustomerAddress model)
  }
}

@enduml
</hidden>


<div style="overflow-y: auto">

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" data-diagram-type="CLASS" height="301px" preserveAspectRatio="none" style="width:1341px;height:301px;background:#FFFFFF;" version="1.1" viewBox="0 0 1341 301" width="1341px" zoomAndPan="magnify"><defs/><g><!--cluster MSSqlDatabase--><g id="cluster_MSSqlDatabase"><path d="M670.5,14.14 L794.9229,14.14 A3.75,3.75 0 0 1 797.4229,16.64 L804.4229,36.4369 L1035.5,36.4369 A2.5,2.5 0 0 1 1038,38.9369 L1038,159.53 A2.5,2.5 0 0 1 1035.5,162.03 L670.5,162.03 A2.5,2.5 0 0 1 668,159.53 L668,16.64 A2.5,2.5 0 0 1 670.5,14.14 " fill="none" style="stroke:#000000;stroke-width:1.5;"/><line style="stroke:#000000;stroke-width:1.5;" x1="668" x2="804.4229" y1="36.4369" y2="36.4369"/><text fill="#000000" font-family="sans-serif" font-size="14" font-weight="bold" lengthAdjust="spacing" textLength="123.4229" x="672" y="29.1351">MSSqlDatabase</text></g><!--cluster ExternalWebServices--><g id="cluster_ExternalWebServices"><path d="M1064.5,30.44 L1232.8916,30.44 A3.75,3.75 0 0 1 1235.3916,32.94 L1242.3916,52.7369 L1331.5,52.7369 A2.5,2.5 0 0 1 1334,55.2369 L1334,143.24 A2.5,2.5 0 0 1 1331.5,145.74 L1064.5,145.74 A2.5,2.5 0 0 1 1062,143.24 L1062,32.94 A2.5,2.5 0 0 1 1064.5,30.44 " fill="none" style="stroke:#000000;stroke-width:1.5;"/><line style="stroke:#000000;stroke-width:1.5;" x1="1062" x2="1242.3916" y1="52.7369" y2="52.7369"/><text fill="#000000" font-family="sans-serif" font-size="14" font-weight="bold" lengthAdjust="spacing" textLength="167.3916" x="1066" y="45.4351">ExternalWebServices</text></g><!--cluster MVC--><g id="cluster_MVC"><path d="M8.5,6 L44.541,6 A3.75,3.75 0 0 1 47.041,8.5 L54.041,28.2969 L641.5,28.2969 A2.5,2.5 0 0 1 644,30.7969 L644,291.98 A2.5,2.5 0 0 1 641.5,294.48 L8.5,294.48 A2.5,2.5 0 0 1 6,291.98 L6,8.5 A2.5,2.5 0 0 1 8.5,6 " fill="none" style="stroke:#000000;stroke-width:1.5;"/><line style="stroke:#000000;stroke-width:1.5;" x1="6" x2="54.041" y1="28.2969" y2="28.2969"/><text fill="#000000" font-family="sans-serif" font-size="14" font-weight="bold" lengthAdjust="spacing" textLength="35.041" x="10" y="20.9951">MVC</text></g><!--class AppDbContext--><g id="elem_AppDbContext"><rect codeLine="3" fill="#F1F1F1" height="96.8906" id="AppDbContext" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="337.459" x="684.27" y="49.14"/><ellipse cx="797.6953" cy="65.14" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M800.664,70.7806 Q800.0859,71.0775 799.4453,71.2181 Q798.8047,71.3744 798.1015,71.3744 Q795.6015,71.3744 794.2734,69.7338 Q792.9609,68.0775 792.9609,64.9525 Q792.9609,61.8275 794.2734,60.1713 Q795.6015,58.515 798.1015,58.515 Q798.8047,58.515 799.4453,58.6713 Q800.1015,58.8275 800.664,59.1244 L800.664,61.8431 Q800.039,61.265 799.4453,60.9994 Q798.8515,60.7181 798.2265,60.7181 Q796.8828,60.7181 796.1953,61.7963 Q795.5078,62.8588 795.5078,64.9525 Q795.5078,67.0463 796.1953,68.1244 Q796.8828,69.1869 798.2265,69.1869 Q798.8515,69.1869 799.4453,68.9213 Q800.039,68.64 800.664,68.0619 L800.664,70.7806 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="102.1084" x="818.1953" y="69.9867">AppDbContext</text><line style="stroke:#181818;stroke-width:0.5;" x1="685.27" x2="1020.729" y1="81.14" y2="81.14"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="325.459" x="690.27" y="98.1351">IRepository&lt;Cusomer&gt; Customers {get; set;}</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="275.0029" x="690.27" y="114.432">IRepository&lt;Order&gt; Orders {get; set;}</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="302.3604" x="690.27" y="130.7289">IRepository&lt;Product&gt; Products {get; set;}</text><line style="stroke:#181818;stroke-width:0.5;" x1="685.27" x2="1020.729" y1="138.0306" y2="138.0306"/></g><!--class ImageService--><g id="elem_ImageService"><rect codeLine="11" fill="#F1F1F1" height="64.2969" id="ImageService" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="240.8193" x="1077.59" y="65.44"/><ellipse cx="1145.9562" cy="81.44" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M1148.925,87.0806 Q1148.3468,87.3775 1147.7062,87.5181 Q1147.0656,87.6744 1146.3625,87.6744 Q1143.8625,87.6744 1142.5343,86.0338 Q1141.2218,84.3775 1141.2218,81.2525 Q1141.2218,78.1275 1142.5343,76.4713 Q1143.8625,74.815 1146.3625,74.815 Q1147.0656,74.815 1147.7062,74.9713 Q1148.3625,75.1275 1148.925,75.4244 L1148.925,78.1431 Q1148.3,77.565 1147.7062,77.2994 Q1147.1125,77.0181 1146.4875,77.0181 Q1145.1437,77.0181 1144.4562,78.0963 Q1143.7687,79.1588 1143.7687,81.2525 Q1143.7687,83.3463 1144.4562,84.4244 Q1145.1437,85.4869 1146.4875,85.4869 Q1147.1125,85.4869 1147.7062,85.2213 Q1148.3,84.94 1148.925,84.3619 L1148.925,87.0806 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="95.5869" x="1166.4562" y="86.2867">ImageService</text><line style="stroke:#181818;stroke-width:0.5;" x1="1078.59" x2="1317.4093" y1="97.44" y2="97.44"/><line style="stroke:#181818;stroke-width:0.5;" x1="1078.59" x2="1317.4093" y1="105.44" y2="105.44"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="228.8193" x="1083.59" y="122.4351">byte[] LoadImage(Guid imageId)</text></g><!--class UpdateCustomerAddressView--><g id="elem_UpdateCustomerAddressView"><rect codeLine="17" fill="#F1F1F1" height="80.5938" id="UpdateCustomerAddressView" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="240.5439" x="69.73" y="57.29"/><ellipse cx="84.73" cy="73.29" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M87.6988,78.9306 Q87.1206,79.2275 86.48,79.3681 Q85.8394,79.5244 85.1363,79.5244 Q82.6363,79.5244 81.3081,77.8838 Q79.9956,76.2275 79.9956,73.1025 Q79.9956,69.9775 81.3081,68.3213 Q82.6363,66.665 85.1363,66.665 Q85.8394,66.665 86.48,66.8213 Q87.1363,66.9775 87.6988,67.2744 L87.6988,69.9931 Q87.0738,69.415 86.48,69.1494 Q85.8863,68.8681 85.2613,68.8681 Q83.9175,68.8681 83.23,69.9463 Q82.5425,71.0088 82.5425,73.1025 Q82.5425,75.1963 83.23,76.2744 Q83.9175,77.3369 85.2613,77.3369 Q85.8863,77.3369 86.48,77.0713 Q87.0738,76.79 87.6988,76.2119 L87.6988,78.9306 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="208.5439" x="98.73" y="78.1367">UpdateCustomerAddressView</text><line style="stroke:#181818;stroke-width:0.5;" x1="70.73" x2="309.2739" y1="89.29" y2="89.29"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="154.7793" x="75.73" y="106.2851">&lt;html&gt;@city&lt;/html&gt;</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="13.3506" x="75.73" y="122.582">...</text><line style="stroke:#181818;stroke-width:0.5;" x1="70.73" x2="309.2739" y1="129.8838" y2="129.8838"/></g><!--class UpdateCustomerAddressViewModel--><g id="elem_UpdateCustomerAddressViewModel"><rect codeLine="22" fill="#F1F1F1" height="113.1875" id="UpdateCustomerAddressViewModel" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="282.5781" x="345.71" y="41"/><ellipse cx="360.71" cy="57" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M363.6788,62.6406 Q363.1006,62.9375 362.46,63.0781 Q361.8194,63.2344 361.1163,63.2344 Q358.6163,63.2344 357.2881,61.5938 Q355.9756,59.9375 355.9756,56.8125 Q355.9756,53.6875 357.2881,52.0313 Q358.6163,50.375 361.1163,50.375 Q361.8194,50.375 362.46,50.5313 Q363.1163,50.6875 363.6788,50.9844 L363.6788,53.7031 Q363.0538,53.125 362.46,52.8594 Q361.8663,52.5781 361.2413,52.5781 Q359.8975,52.5781 359.21,53.6563 Q358.5225,54.7188 358.5225,56.8125 Q358.5225,58.9063 359.21,59.9844 Q359.8975,61.0469 361.2413,61.0469 Q361.8663,61.0469 362.46,60.7813 Q363.0538,60.5 363.6788,59.9219 L363.6788,62.6406 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="250.5781" x="374.71" y="61.8467">UpdateCustomerAddressViewModel</text><line style="stroke:#181818;stroke-width:0.5;" x1="346.71" x2="627.2881" y1="73" y2="73"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="115.8896" x="351.71" y="89.9951">Guid customerId</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="98.1777" x="351.71" y="106.292">string country</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="70" x="351.71" y="122.5889">string city</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="99.9482" x="351.71" y="138.8857">string address</text><line style="stroke:#181818;stroke-width:0.5;" x1="346.71" x2="627.2881" y1="146.1875" y2="146.1875"/></g><!--class CustomerController--><g id="elem_CustomerController"><rect codeLine="28" fill="#F1F1F1" height="64.2969" id="CustomerController" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="606.1934" x="21.9" y="214.18"/><ellipse cx="252.1583" cy="230.18" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M255.1271,235.8206 Q254.5489,236.1175 253.9083,236.2581 Q253.2677,236.4144 252.5646,236.4144 Q250.0646,236.4144 248.7364,234.7738 Q247.4239,233.1175 247.4239,229.9925 Q247.4239,226.8675 248.7364,225.2113 Q250.0646,223.555 252.5646,223.555 Q253.2677,223.555 253.9083,223.7113 Q254.5646,223.8675 255.1271,224.1644 L255.1271,226.8831 Q254.5021,226.305 253.9083,226.0394 Q253.3146,225.7581 252.6896,225.7581 Q251.3458,225.7581 250.6583,226.8363 Q249.9708,227.8988 249.9708,229.9925 Q249.9708,232.0863 250.6583,233.1644 Q251.3458,234.2269 252.6896,234.2269 Q253.3146,234.2269 253.9083,233.9613 Q254.5021,233.68 255.1271,233.1019 L255.1271,235.8206 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="137.1768" x="272.6583" y="235.0267">CustomerController</text><line style="stroke:#181818;stroke-width:0.5;" x1="22.9" x2="627.0934" y1="246.18" y2="246.18"/><line style="stroke:#181818;stroke-width:0.5;" x1="22.9" x2="627.0934" y1="254.18" y2="254.18"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="594.1934" x="27.9" y="271.1751">Task&lt;IActionResult&gt; ChangeFirstName([FromBody]UpdateCustomerAddress model)</text></g><!--SRC=[XL7BJiCm4BpdA_POBkK3Y2fAIb4a2gY5SgXwSEnLQjM9WtS3ZQB-EucJy2W8BlPuF9gPjGiXzo95MAnMBsOcM2I2i0u206a44KoBOfP4DcSySDsm0F4I2qkQhQl2g2IRePj00xX517MAV07KBCSVydkdMh7V_bO-EAjAoHFemQdw61o3eEYxNnyONIxCCoOhTAzQ8jKV0yHP8-dfRe2aOjniuTOAvIz7DwLMe5iOgxDJyyKw-ZHxAfHW78QTAkMGQAtnhPM4EyxCv59ghi9pZnjoF1vxn_yj5bQXwHhwGhANnCfpn4xdAKXRvkmg-COrYL_FeZFrkKFi4DX-fRF6eEkY7WNjmtWgMTjyYLIQvisZdSXJd6j7V2So76tcpcPNLbNRNyj3rZRl7-uT]--></g></svg>

</div>

### Frameworks & Drivers

The outermost layer is generally composed of frameworks and tools, such as the Database and the Web Framework. Typically, this layer requires only minimal 'glue code' to interface with the next inner circle.

### Control flow

**Request from the UI**: A user interacts with the user interface, triggering a request. This could be anything, like clicking a button or submitting a form.   

**Controller**: The request is received by a controller in the `Presentation layer`. The controller's job is to translate the request into a format that the `Use Case` layer can understand. It doesn't contain any business logic itself.   

**Use Case**: The controller calls a specific `Use Case` in the `Application layer`. This `Use Case` encapsulates the business logic for that particular request. It orchestrates the necessary actions, potentially interacting with entities in the `Domain layer`.   

**Entities**: The `Use Case` might interact with entities in the `Domain layer`. `Entities` represent the core concepts of the application and contain business logic related to those concepts.   

**Data Access**: If the `Use Case` needs to retrieve or store data, it will interact with an interface in the `Application layer`, which handles the specifics of data access (e.g., database, API), and which implementation resides in the `Infrastructure layer`.   

**Presenter**: Once the `Use Case` has completed its work, it passes the *results*(data) to a `Presenter` in the `Presentation layer`. The `Presenter's` job is to **format the data** in a way that the UI can understand.   

**UI Update**: The `Presenter` updates the UI with the results of the Use Case.

![clean arhitecture control flow](images/clean_arhitecture_control_flow.drawio.png)

### Code Example

[clean-architecture-example of TODO application](https://github.com/ichensky/clean-architecture-example/)