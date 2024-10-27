import 'package:flutter/material.dart';
import 'package:sharara_bottom_bar/sharara_bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class  MyApp extends StatelessWidget {
  const  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner:false,
      home: FirstScreen(),
    );
  }
}
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      bottomNavigationBar: ShararaBottomBar(
       controller:ShararaBottomBarController(
         items: const [
           ShararaBottomItem(child: Icon(Icons.home),label: "الرئيسية"),
           ShararaBottomItem(child: Icon(Icons.gamepad),label: "الاقسام"),
           ShararaBottomItem(child: Icon(Icons.shopping_cart),label: "العربة"),
           ShararaBottomItem(child: Icon(Icons.person,color:Colors.black,),
             label:"الحساب الشخصي"
            ),
         ],
       ),
    )
    );
  }
}
