# Dependency Inversion Principle

Martin, Robert C. 
  > A. High-level modules should not depend upon low-level modules. Both should depend upon abstractions.

  > B. Abstractions should not depend upon details. Details should depend upon abstractions.

This principle is intended to reduce coupling in code, making software easier to modify. Changes in one module should not affect the behavior of other modules.

## Example of violation DIP

Class `Button` depends on class `Lamp`.<br> 
High level module `Button` depends on low level module `Lamp`.<br>
1. Every time the `Lamp` class is modified, the `Button` class must be correspondingly adjusted.

```csharp
var lamp = new Lamp();
var button = new Button(lamp);

button.Click(); // The lamp is on.
button.Click(); // The lamp is off.
button.Click(); // The lamp is on.

class Lamp
{
    public void TurnOnLamp() => Console.WriteLine("The lamp is on.");

    public void TurnOffLamp() => Console.WriteLine("The lamp is off.");

    public string GetLampName() => "Lamp name.";
}

enum ButtonState
{
    On = 1,

    Off = 2,
}


class Button(Lamp lamp)
{
    private ButtonState buttonState = ButtonState.Off;

    public ButtonState GetButtonState() => this.buttonState;

    public void Click()
    {
        switch (buttonState)
        {
            case ButtonState.On:
                // `Button` depends on `lamp`
                lamp.TurnOffLamp();
                buttonState = ButtonState.Off;
                return;
            case ButtonState.Off:
                // `Button` depends on `lamp`
                lamp.TurnOnLamp();
                buttonState = ButtonState.On;
                return;
            default:
                throw new NotImplementedException();
        }
    }
}
```

2. Reusing the `Button` class for another device, such as a `Kettle`, is not feasible because the `Button` class is directly dependent on the `Lamp` class. It directly calls `Lamp` methods.

```csharp
class Kettle
{
    public void TurnOnKettle() => Console.WriteLine("The kettle is on.");

    public void TurnOffKettle() => Console.WriteLine("The kettle is off.");
}
```

## Improving code to follow DIP
In `C#`, abstraction can be presented either with an `interface` or an `abstract class`.

To separate abstractions from realisations, the example above can be re-worked by introducing for each class abstractions: `IDevice`, `ILamp`, `ButtonBase`.

```csharp
IDevice device = new Lamp();
ButtonBase button = new MyButton(device);

button.Click(); // The lamp is on.
button.Click(); // The lamp is off.
button.Click(); // The lamp is on.

// abstraction
interface IDevice
{
    void TurnOnDevice();

    void TurnOffDevice();
}

// abstraction
interface ILamp : IDevice
{
    string GetLampName();
}

class Lamp : ILamp
{
    public void TurnOnDevice() => Console.WriteLine("The lamp is on.");

    public void TurnOffDevice() => Console.WriteLine("The lamp is off.");

    public string GetLampName() => "Lamp name.";
}


enum ButtonState
{
    On = 1,

    Off = 2,
}

// abstraction
abstract class ButtonBase(IDevice device)
{
    protected ButtonState buttonState = ButtonState.Off;

    public void Click()
    {
        switch (buttonState)
        {
            case ButtonState.On:
                device.TurnOnDevice();
                buttonState = ButtonState.Off;
                return;
            case ButtonState.Off:
                device.TurnOffDevice();
                buttonState = ButtonState.On;
                return;
            default:
                throw new NotImplementedException();
        }
    }
}

class MyButton(IDevice device) : ButtonBase(device)
{
    public ButtonState GetButtonState() => this.buttonState;
}

```

`abstract class` `ButtonBase` depends on the abstraction `IDevice`.<br>
The `Lamp` class implements the `ILamp` `interface` and, `indirectly`, the `IDevice` abstraction. Changes made to the `Lamp` class will not impact any implementation of the `ButtonBase` class, such as `MyButton`.

Separating abstractions from implementations makes the code more resilient to change and significantly easier to maintain.