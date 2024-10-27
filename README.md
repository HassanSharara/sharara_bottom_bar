

# introduction 
fast built package for providing convex bottom bar view with very fast render rate


## installation.
```shell
flutter pub add sharara_bottom_bar
```



## Usage

```dart
 final bottom = ShararaBottomBar(
controller:ShararaBottomBarController(
items: const [
ShararaBottomItem(child: Icon(Icons.home),label: "main"),
ShararaBottomItem(child: Icon(Icons.gamepad),label: "categories"),
ShararaBottomItem(child: Icon(Icons.shopping_cart),label: "cart"),
ShararaBottomItem(child: Icon(Icons.person,color:Colors.black,),
label:"profile"
),
],
),
);
```

