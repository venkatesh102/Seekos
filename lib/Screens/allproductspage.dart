

import 'dart:developer';

// import '../Screens/chat_screen.dart';
import '../Screens/homescreen.dart';
import '../methods/appconstants.dart';
import '../methods/providerclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'productsdetailspage.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);
  static const String id = 'allproductslist';
  @override
  State<AllProducts> createState() => _AllProductsState();
}

FirebaseServices _services = FirebaseServices();

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<ProductProvider>(context);
    return Container(
      // height: 1000,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: StreamBuilder<QuerySnapshot>(
          stream: _services.productData.orderBy('postOn').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                  padding: EdgeInsets.only(left: 140, right: 140),
                  child: Center(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ));
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40,
                      padding: EdgeInsets.all(8),
                      child: Text('FRESH RECOMANDATIONS',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2 / 2.3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 10),
                      itemCount: snapshot.data!.size,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data!.docs[index];
                        return Stack(children:[
                          OutlinedButton(
                              style:OutlinedButton.styleFrom(side:BorderSide(width: 0)),
                              onPressed: () {
                                var productId = snapshot.data!.docs[index].id;
                                var sellerId =
                                snapshot.data!.docs[index]['sellerUid'];
                                log(productId);
                                _provider.getProductDetails(
                                    snapshot.data!.docs[index]);
                                // print('object');
                                Navigator.pushNamed(
                                  context,
                                  ProductDetailsPage.id,
                                );
                              },
                              child: Container(
                                // alignment: Alignment.center,
                                // height: 500,
                                // color: Colors.white,
                                // decoration: BoxDecoration(
                                //   borderRadius:BorderRadius.circular(5),
                                //     border: Border.all(
                                //         color: Theme.of(context)
                                //             .primaryColor
                                //             .withOpacity(.8))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(

                                          height: 100,
                                          // color: Colors.blue,
                                          child: Center(
                                            child: FittedBox(
                                              child: Image.network(
                                                data['images'][0],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 8),
                                      child: Text(
                                        data['productName'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 8),
                                      child: Text(data['subCategory'],
                                          style: TextStyle(fontSize: 10,color: Colors.black)),
                                    )
                                  ],
                                ),
                              )),Container(margin:EdgeInsets.only(right: 5,top: 5),alignment:Alignment.topRight,child: CircleAvatar(backgroundColor: Colors.white,child:IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.heart,color: Colors.black,)) )),]);
                      })
                ]);
            // else {
            //   return CircularProgressIndicator();
            // }
          },
        ),
      ),
    );
  }
}
