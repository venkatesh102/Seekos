import '../Screens/pendingverificationpage.dart';
import '../Screens/sellerregistrationpage.dart';
import '../methods/providerclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../methods/appconstants.dart';
import 'sell_subcategory_selectpage.dart';
import 'package:provider/provider.dart';
class SellCategoriesSelectPage extends StatefulWidget {
  const SellCategoriesSelectPage({Key? key}) : super(key: key);
  static const String id = 'sellcategory';
  @override
  State<SellCategoriesSelectPage> createState() => _SellCategoriesSelectPageState();
}

class _SellCategoriesSelectPageState extends State<SellCategoriesSelectPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _catProvider=Provider.of<CategoryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Color(colour), title: Text('Select Category')),
      body: FutureBuilder(
        future: _firebaseServices.categories.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return GestureDetector(
                    onTap: () {
                      _catProvider.getCategory(data['CatName']);
                      _catProvider.getCatSnapshot(data);
                      if (data['subCat'] != null) {
                        Navigator.pushNamed(context, SellSubCategoriesSelectPage.id,
                            arguments: data);
                      }
                    },
                    child: SizedBox(
                        height: 100,
                        child: ListTile(
                          leading: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.saturation,
                            ),
                          child:Image.network(data['image'],),
                          ),
                          title: Text(
                            data['CatName'],
                          ),
                        )));
              });
        },
      ),
    );
  }
}

