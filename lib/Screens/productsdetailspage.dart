


import 'dart:async';

import '../methods/appconstants.dart';
import '../methods/providerclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import 'pendingverificationpage.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);
  static const String id = 'productdetails';
  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  FirebaseServices _services=FirebaseServices();
  bool _loading = true;
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    // String ownerId= ModalRoute.of(context)?.settings.arguments as String;
    var _provider = Provider.of<ProductProvider>(context);
    var data = _provider.ProductDetails;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(
                Icons.share_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: Text(
                    data['images'].length.toString(),
                  ),
                  alignment: Alignment.center,
                ),
                GestureDetector(
                  onTap: () {
                    GalleryImage(
                      numOfShowImages: 1,
                      imageUrls: [data['images'].toString()],
                    );
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      color: Colors.grey.shade300,
                      child: _loading
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 10,
                              width: 0,
                            ),
                            Text('Loading Your Ad')
                          ],
                        ),
                      )
                          :
                      // Column(children:[PhotoView(backgroundDecoration:BoxDecoration(color: Colors.grey.shade300),imageProvider:NetworkImage(data['images'][0]))

                      PageView.builder(
                        itemCount: data['images'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 300,
                            child: Center(
                                child: PhotoView(
                                    minScale:
                                    PhotoViewComputedScale.contained,
                                    imageProvider: NetworkImage(
                                      _provider.ProductDetails['images']
                                      [index],
                                    ))),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                alignment: Alignment.topLeft,
                child: Text(
                  data['productName'],
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.normal),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  data['description'],
                  // style: TextStyle(fontSize: 16,fontFamily: 'Ariel',fontWeight: FontWeight.normal),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    data['year'] == 'New'
                        ? Text(data['year'] + ' product')
                        : Text(data['yearscount'] == '1'
                        ? data['yearscount'] + ' year old '
                        : data['yearscount'] + ' years old')
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 10, 20, 0),
                alignment: Alignment.topLeft,
                child: Row(children: [
                  Text(
                    'Location:',
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(data['city'] + ',' + data['state']),
                ]
                  // style: TextStyle(fontSize: 16,fontFamily: 'Ariel',fontWeight: FontWeight.normal)
                ))
          ],
        ),
      ),

      bottomSheet:data['sellerUid'].toString()!=_services.user!.uid ?Container(
        height: 65,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment,
          children: [
            Expanded(
                child: InkWell(
                  onLongPress: () {
                    Text('chat');
                  },
                  onTap: () {
                    _provider.getProductDetails(data);
                    // Navigator.of(context)
                        // .pushNamed();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'CHAT',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(colour)),
                  ),
                )),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: InkWell(
                  onTap: () {
                    _provider.getProductDetails(data);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      'PLACE A BID',
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(colour)),
                  ),
                )),
            SizedBox(
              height: 200,
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.black)),
      ):Text(''),
    );
  }
}
