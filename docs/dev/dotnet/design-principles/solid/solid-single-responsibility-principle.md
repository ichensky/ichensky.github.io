# Single Responsibility Principle (SRP)

Robert C. Martin:
[srp.pdf](https://web.archive.org/web/20150202200348/http://www.objectmentor.com/resources/articles/srp.pdf)
> There should never be more than one reason for a class to change.

Martin, Robert C. (2018). Clean architecture: a craftsman's guide to software structure and design:
> A module should be responsible to one, and only one, actor.

This `principle` is `violated` when `two or more actors` `use the same class`.

By an actor means a person or a group of people. Actor that's the single reason to change a module.

By `module` means a file with source code, which has structures and function related to each other. Object oriented, languages as `C#` place code in `classes`, in this case `module` can be interpreted as a `class`.

### Example of violation the principle 

An online shop have a `Product` class, which contains data such as title, description and price. The Product class have two associated pages: one for users and one for the seller. It also contains shared method `GetProductInformation` which is both used by users and a seller.

`Users` and `seller` are `actors`.<br>
`Product` class and its method `GetProductInformation` is `shared` between them and exactly this `violates` `Single Responsibility Principle`.
<hidden style="display:none">
@startuml
actor Seller
participant Product
actor Users
Seller -> Product : ctor
Seller -> Product : UpdateDescription()
Seller -> Product : UpdatePrice()
Users -> Product : GetProductInformation()
Product --> Users : ProductInformation
Seller -> Product : GetProductInformation()
Product --> Seller : ProductInformation
@enduml
</hidden>

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" data-diagram-type="SEQUENCE" height="386px" preserveAspectRatio="none" style="width:416px;height:386px;background:#FFFFFF;" version="1.1" viewBox="0 0 416 386" width="416px" zoomAndPan="magnify"><defs/><g><line style="stroke:#181818;stroke-width:0.5;stroke-dasharray:5.0,5.0;" x1="27" x2="27" y1="81.2969" y2="305.2266"/><line style="stroke:#181818;stroke-width:0.5;stroke-dasharray:5.0,5.0;" x1="209.6353" x2="209.6353" y1="81.2969" y2="305.2266"/><line style="stroke:#181818;stroke-width:0.5;stroke-dasharray:5.0,5.0;" x1="392.5542" x2="392.5542" y1="81.2969" y2="305.2266"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="39.6484" x="5" y="77.9951">Seller</text><ellipse cx="27.8242" cy="13.5" fill="#E2E2F0" rx="8" ry="8" style="stroke:#181818;stroke-width:0.5;"/><path d="M27.8242,21.5 L27.8242,48.5 M14.8242,29.5 L40.8242,29.5 M27.8242,48.5 L14.8242,63.5 M27.8242,48.5 L40.8242,63.5 " fill="none" style="stroke:#181818;stroke-width:0.5;"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="39.6484" x="5" y="317.2217">Seller</text><ellipse cx="27.8242" cy="329.0234" fill="#E2E2F0" rx="8" ry="8" style="stroke:#181818;stroke-width:0.5;"/><path d="M27.8242,337.0234 L27.8242,364.0234 M14.8242,345.0234 L40.8242,345.0234 M27.8242,364.0234 L14.8242,379.0234 M27.8242,364.0234 L40.8242,379.0234 " fill="none" style="stroke:#181818;stroke-width:0.5;"/><rect fill="#E2E2F0" height="30.2969" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="67.71" x="176.6353" y="50"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="53.71" x="183.6353" y="69.9951">Product</text><rect fill="#E2E2F0" height="30.2969" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="67.71" x="176.6353" y="304.2266"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="53.71" x="183.6353" y="324.2217">Product</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="39.2041" x="370.5542" y="77.9951">Users</text><ellipse cx="393.1563" cy="13.5" fill="#E2E2F0" rx="8" ry="8" style="stroke:#181818;stroke-width:0.5;"/><path d="M393.1563,21.5 L393.1563,48.5 M380.1563,29.5 L406.1563,29.5 M393.1563,48.5 L380.1563,63.5 M393.1563,48.5 L406.1563,63.5 " fill="none" style="stroke:#181818;stroke-width:0.5;"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="39.2041" x="370.5542" y="317.2217">Users</text><ellipse cx="393.1563" cy="329.0234" fill="#E2E2F0" rx="8" ry="8" style="stroke:#181818;stroke-width:0.5;"/><path d="M393.1563,337.0234 L393.1563,364.0234 M380.1563,345.0234 L406.1563,345.0234 M393.1563,364.0234 L380.1563,379.0234 M393.1563,364.0234 L406.1563,379.0234 " fill="none" style="stroke:#181818;stroke-width:0.5;"/><polygon fill="#181818" points="198.4902,108.4297,208.4902,112.4297,198.4902,116.4297,202.4902,112.4297" style="stroke:#181818;stroke-width:1;"/><line style="stroke:#181818;stroke-width:1;" x1="27.8242" x2="204.4902" y1="112.4297" y2="112.4297"/><text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="25.543" x="34.8242" y="107.3638">ctor</text><polygon fill="#181818" points="198.4902,137.5625,208.4902,141.5625,198.4902,145.5625,202.4902,141.5625" style="stroke:#181818;stroke-width:1;"/><line style="stroke:#181818;stroke-width:1;" x1="27.8242" x2="204.4902" y1="141.5625" y2="141.5625"/><text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="131.2632" x="34.8242" y="136.4966">UpdateDescription()</text><polygon fill="#181818" points="198.4902,166.6953,208.4902,170.6953,198.4902,174.6953,202.4902,170.6953" style="stroke:#181818;stroke-width:1;"/><line style="stroke:#181818;stroke-width:1;" x1="27.8242" x2="204.4902" y1="170.6953" y2="170.6953"/><text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="89.1655" x="34.8242" y="165.6294">UpdatePrice()</text><polygon fill="#181818" points="221.4902,195.8281,211.4902,199.8281,221.4902,203.8281,217.4902,199.8281" style="stroke:#181818;stroke-width:1;"/><line style="stroke:#181818;stroke-width:1;" x1="215.4902" x2="392.1563" y1="199.8281" y2="199.8281"/><text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="158.666" x="227.4902" y="194.7622">GetProductInformation()</text><polygon fill="#181818" points="381.1563,224.9609,391.1563,228.9609,381.1563,232.9609,385.1563,228.9609" style="stroke:#181818;stroke-width:1;"/><line style="stroke:#181818;stroke-width:1;stroke-dasharray:2.0,2.0;" x1="210.4902" x2="387.1563" y1="228.9609" y2="228.9609"/><text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="125.3535" x="217.4902" y="223.895">ProductInformation</text><polygon fill="#181818" points="198.4902,254.0938,208.4902,258.0938,198.4902,262.0938,202.4902,258.0938" style="stroke:#181818;stroke-width:1;"/><line style="stroke:#181818;stroke-width:1;" x1="27.8242" x2="204.4902" y1="258.0938" y2="258.0938"/><text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="158.666" x="34.8242" y="253.0278">GetProductInformation()</text><polygon fill="#181818" points="38.8242,283.2266,28.8242,287.2266,38.8242,291.2266,34.8242,287.2266" style="stroke:#181818;stroke-width:1;"/><line style="stroke:#181818;stroke-width:1;stroke-dasharray:2.0,2.0;" x1="32.8242" x2="209.4902" y1="287.2266" y2="287.2266"/><text fill="#000000" font-family="sans-serif" font-size="13" lengthAdjust="spacing" textLength="125.3535" x="44.8242" y="282.1606">ProductInformation</text><!--SRC=[IqmkoIzI24xDoKajuYf8B2h9JCuiICmhKGWeoayfJIxXIWGh22rEBIhcWYXJqBM3oIfOAO2aiKg45gGabgIwf1Od5sKMb6Jcvsbeub4NK9IPd0fK0RO8LO5xQWcKuvcNbb-KcmWr3AP25wWQeirA0LCXLZk9CHAg3vkP0000]--></g></svg>

```csharp
// Online shop.
//
// Actors: Seller, Users
//


// Razor page1, used by Seller
{
    Product product = ...;
    var productInformation = product.GetProductInformation();
}

// Razor page2, used by Users
{
    Product product = ...;
    var productInformation = product.GetProductInformation();
}


class Product
{
    private string title;
    private string description;
    private decimal price;

    public Product(string title, string description, decimal price)
    {
        this.title = title;
        this.description = description;
        this.price = price;
    }

    public void UpdateDescription(string description)
    {
        this.description = description;
    }

    public void UpdatePrice(decimal price)
    {
        this.price = price;
    }

    public ProductInformation GetProductInformation() 
    {
        return new ProductInformation(this.title, this.description, this.price);
    }
}

record ProductInformation(string Title, string Description, decimal Price);
```


### Issue of violation the principle 
The issue of `sharing the same class` between `actors` is that if the `Product` class needs to change, for example, the `GetProductInformation()` method, to return `{Title} ${Price}` for Seller instead of `Title`, it would be necessary to consider how not to break existing functionality for `Users`.

```csharp
    public ProductInformation GetProductInformation() 
    {
        // Bug: After deployment, 
        // `Seller` will see the new update title, 
        // but `Users` will see an incorrect one.
        return new ProductInformation($"{this.title} ${this.price}", this.description, this.price);
    }

```

### Code improvement 
There are many ways to improve code by following the `Single Responsibility Principle`. However, all of these approaches boil down to separating methods into different classes. One example is inheritance.

Logic from class Product is split between `SellerProduct` and `UsersProduct` classes.
<hidden style="display:none">
@startuml
abstract Product{
 string title;
 string description;
 decimal price;
 Product(string title, string description, decimal price)
}
class SellerProduct{ 
void UpdateDescription()
void UpdatePrice()
SellerProductInformation GetSellerProductInformation()
}
class UsersProduct { 
UsersProductInformation GetUsersProductInformation()
}
Product <|-- SellerProduct
Product <|-- UsersProduct
@enduml
</hidden>


<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" contentStyleType="text/css" data-diagram-type="CLASS" height="284px" preserveAspectRatio="none" style="width:851px;height:284px;background:#FFFFFF;" version="1.1" viewBox="0 0 851 284" width="851px" zoomAndPan="magnify"><defs/><g><!--class Product--><g id="elem_Product"><rect codeLine="1" fill="#F1F1F1" height="113.1875" id="Product" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="383.4102" x="234.1" y="7"/><ellipse cx="394.7001" cy="23" fill="#A9DCDF" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M394.8095,18.3438 L393.6532,23.4219 L395.9813,23.4219 L394.8095,18.3438 Z M393.3251,16.1094 L396.3095,16.1094 L399.6688,28.5 L397.2157,28.5 L396.4501,25.4375 L393.1688,25.4375 L392.4188,28.5 L389.9813,28.5 L393.3251,16.1094 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" font-style="italic" lengthAdjust="spacing" textLength="53.71" x="415.2001" y="27.8467">Product</text><line style="stroke:#181818;stroke-width:0.5;" x1="235.1" x2="616.5102" y1="39" y2="39"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="76.7266" x="240.1" y="55.9951">string title;</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="127.1963" x="240.1" y="72.292">string description;</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="99.2031" x="240.1" y="88.5889">decimal price;</text><line style="stroke:#181818;stroke-width:0.5;" x1="235.1" x2="616.5102" y1="95.8906" y2="95.8906"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="371.4102" x="240.1" y="112.8857">Product(string title, string description, decimal price)</text></g><!--class SellerProduct--><g id="elem_SellerProduct"><rect codeLine="7" fill="#F1F1F1" height="96.8906" id="SellerProduct" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="401.6143" x="7" y="180.19"/><ellipse cx="156.8779" cy="196.19" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M159.8467,201.8306 Q159.2686,202.1275 158.6279,202.2681 Q157.9873,202.4244 157.2842,202.4244 Q154.7842,202.4244 153.4561,200.7838 Q152.1436,199.1275 152.1436,196.0025 Q152.1436,192.8775 153.4561,191.2213 Q154.7842,189.565 157.2842,189.565 Q157.9873,189.565 158.6279,189.7213 Q159.2842,189.8775 159.8467,190.1744 L159.8467,192.8931 Q159.2217,192.315 158.6279,192.0494 Q158.0342,191.7681 157.4092,191.7681 Q156.0654,191.7681 155.3779,192.8463 Q154.6904,193.9088 154.6904,196.0025 Q154.6904,198.0963 155.3779,199.1744 Q156.0654,200.2369 157.4092,200.2369 Q158.0342,200.2369 158.6279,199.9713 Q159.2217,199.69 159.8467,199.1119 L159.8467,201.8306 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="93.3584" x="177.3779" y="201.0367">SellerProduct</text><line style="stroke:#181818;stroke-width:0.5;" x1="8" x2="407.6143" y1="212.19" y2="212.19"/><line style="stroke:#181818;stroke-width:0.5;" x1="8" x2="407.6143" y1="220.19" y2="220.19"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="175.4375" x="13" y="237.1851">void UpdateDescription()</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="130.1016" x="13" y="253.482">void UpdatePrice()</text><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="389.6143" x="13" y="269.7789">SellerProductInformation GetSellerProductInformation()</text></g><!--class UsersProduct--><g id="elem_UsersProduct"><rect codeLine="12" fill="#F1F1F1" height="64.2969" id="UsersProduct" rx="2.5" ry="2.5" style="stroke:#181818;stroke-width:0.5;" width="400.7256" x="443.44" y="196.49"/><ellipse cx="593.0958" cy="212.49" fill="#ADD1B2" rx="11" ry="11" style="stroke:#181818;stroke-width:1;"/><path d="M596.0645,218.1306 Q595.4864,218.4275 594.8458,218.5681 Q594.2051,218.7244 593.502,218.7244 Q591.002,218.7244 589.6739,217.0837 Q588.3614,215.4275 588.3614,212.3025 Q588.3614,209.1775 589.6739,207.5212 Q591.002,205.865 593.502,205.865 Q594.2051,205.865 594.8458,206.0212 Q595.502,206.1775 596.0645,206.4744 L596.0645,209.1931 Q595.4395,208.615 594.8458,208.3494 Q594.252,208.0681 593.627,208.0681 Q592.2833,208.0681 591.5958,209.1462 Q590.9083,210.2087 590.9083,212.3025 Q590.9083,214.3962 591.5958,215.4744 Q592.2833,216.5369 593.627,216.5369 Q594.252,216.5369 594.8458,216.2712 Q595.4395,215.99 596.0645,215.4119 L596.0645,218.1306 Z " fill="#000000"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="92.9141" x="613.5958" y="217.3367">UsersProduct</text><line style="stroke:#181818;stroke-width:0.5;" x1="444.44" x2="843.1656" y1="228.49" y2="228.49"/><line style="stroke:#181818;stroke-width:0.5;" x1="444.44" x2="843.1656" y1="236.49" y2="236.49"/><text fill="#000000" font-family="sans-serif" font-size="14" lengthAdjust="spacing" textLength="388.7256" x="449.44" y="253.4851">UsersProductInformation GetUsersProductInformation()</text></g><!--reverse link Product to SellerProduct--><g id="link_Product_SellerProduct"><path codeLine="15" d="M336.6739,131.2585 C310.9139,150.5185 296.72,161.13 271.89,179.71 " fill="none" id="Product-backto-SellerProduct" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="351.09,120.48,333.0811,126.4531,340.2667,136.0639,351.09,120.48" style="stroke:#181818;stroke-width:1;"/></g><!--reverse link Product to UsersProduct--><g id="link_Product_UsersProduct"><path codeLine="16" d="M514.9459,131.2588 C548.7159,156.5088 572.96,174.65 601.6,196.07 " fill="none" id="Product-backto-UsersProduct" style="stroke:#181818;stroke-width:1;"/><polygon fill="none" points="500.53,120.48,511.3529,136.0641,518.5388,126.4535,500.53,120.48" style="stroke:#181818;stroke-width:1;"/></g><!--SRC=[TOyn3i8m34NtdC9ZAxKdW149iLL2FK183BAKDfLZkW1t9qKjJH0T_Vz_txQ-165j11hszcxaeI0ArDz0I1pklgF5O9W68Tz7qQAXJZiOcCmKckaYPQi_Q9MJfNefutG8S4Rda9SZG8sUBBI3rOA75I_Ar6YcYYXbxAc_Ukxqb8OZofPNhAlRW1pc1CJLwVpJjc5zofQ6_REkytToA-ru0m00]--></g></svg>

```csharp
abstract class Product
{
    protected string title;
    protected string description;
    protected decimal price;

    public Product(string title, string description, decimal price)
    {
        this.title = title;
        this.description = description;
        this.price = price;
    }
}

// Actor `Seller` has its own class to interact with
sealed class SellerProduct : Product
{
    public SellerProduct(string title, string description, decimal price): base(title, description, price) { }

    public void UpdateDescription(string description)
    {
        this.description = description;
    }

    public void UpdatePrice(decimal price)
    {
        this.price = price;
    }

    public SellerProductInformation GetSellerProductInformation() 
    {
        return new SellerProductInformation($"{this.title} ${this.price}", this.description, this.price);
    }
}

record SellerProductInformation(string Title, string Description, decimal Price);

// Actor `Users` has its own class to interact with
sealed class UsersProduct : Product
{
    public UsersProduct(string title, string description, decimal price) : base(title, description, price) { }

    public UsersProductInformation GetUsersProductInformation()
    {
        return new UsersProductInformation(this.title, this.description, this.price);
    }
}

record UsersProductInformation(string Title, string Description, decimal Price);
```