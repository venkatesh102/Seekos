import 'dart:async';
import '../Screens/allproductspage.dart';
import '../Screens/category.dart';
import '../Screens/pendingverificationpage.dart';
import '../methods/providerclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:photo_view/photo_view.dart';
import '../methods/drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'homescreen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(colour),
        title: Text(
          'BidOnBuy ',
        ),
      ),
      drawer: buildDrawer(context),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Categories(),
            SizedBox(
              height: 0,
            ),
            // Divider(thickness: 5,color: Colors.orange,),
            AllProducts()
          ],
        ),
      ),
    );
  }
}

