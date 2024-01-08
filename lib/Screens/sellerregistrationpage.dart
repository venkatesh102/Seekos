import 'dart:io';

import 'package:seekos/main.dart';
import 'package:seekos/methods/appconstants.dart';
import  '../methods/imagepicker.dart';
import  '../Screens/pendingverificationpage.dart';
import  '../methods/providerclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SellerRegistration extends StatefulWidget {
  // const ({Key? key}) : super(key: key);
  static const String id = 'sellerregistration';

  const SellerRegistration({super.key});
  @override
  State<SellerRegistration> createState() => _SellerRegistrationState();
}
FirebaseServices _services=FirebaseServices();

class _SellerRegistrationState extends State<SellerRegistration> {
  @override

  TextEditingController _product_name = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _years = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  List<XFile?> _productImageList=[];
  Object? selectedAge = 'New';
  String selectedCountry = '';
  var selectedState=null;
  late Future<PickedFile> pickedfile=Future.value(null);
  var selectedCity=null;
  bool loading=false;
  bool locationValidation(var state,var city)
  {
    if(state!=null&&city!=null){
      return true;
    }
    else{
      // Message(context, 'Please provide valid address');
      return false;
    }

  }
  validate(CategoryProvider provider) async {
    if (_formkey.currentState!.validate()) {
      // print('object');
      if (_productImageList.isNotEmpty) {
     // List<String> images=await uploadMultiImage(_productImageList);
     setState(() {

     });
        provider.dataToFirestore.addAll({
          'category': provider.selectedCategory,
          'productName': _product_name.text,
          'country': selectedCountry.toString(),
          'state': selectedState,
          'city': selectedCity,
          'year': selectedAge,
          'sellerUid': _services.user!.uid,
          // 'image':[provider.ImageUrlList]
        });
      }
    }
    else{
      Message(context, 'No image selcted') ;
    }
  }
  Widget build(BuildContext context) {
var _provider=Provider.of<CategoryProvider>(context);

    return Scaffold(
        appBar: AppBar(backgroundColor: Color(colour),
          title: Text('Seller registration form'),
        ),
        body:loading?Center(child: CircularProgressIndicator()):Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  if(_provider.ImageUrlList.length>0)
                    Container(
                        decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.circular(4)), child:GalleryImage(numOfShowImages:_provider.selectedImages,imageUrls: _provider.ImageUrlList,)),
                  SizedBox(
                    height: 0,
                  ),
                  // FutureBuilder<PickedFile?>(
                  //   future: pickedfile,
                  //   builder: (context, snap) {
                  //     if (snap.hasData) {
                  //       return Container(
                  //         child: Image.file(
                  //           File(snap.data!.path),
                  //           fit: BoxFit.contain,
                  //         ),
                  //         color: Colors.blue,
                  //       );
                  //     }
                  //     return Container(
                  //       height: 200.0,
                  //       color: Colors.blue,
                  //     );
                  //   },
                  // ),
                  GestureDetector(
                    onTap: () async {
                      _productImageList = await multiImagePicker();
                      Message(context, _productImageList.length.toString()+' images selected') ;
                      if(_productImageList.isNotEmpty){
                        setState(() {

                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Select product images',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          // gradient: LinearGradient(
                          //     colors: [(Color(0xffF5591E)), Color(0xffF2861E)]),
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff57140173)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      controller: _product_name,
                      validator: (item) {
                        return item!.length > 0
                            ? null
                            : 'product name can\'t be empty';
                      },
                      onChanged: (item) {},
                      keyboardType: TextInputType.text,
                      cursorColor: Color(colour),
                      decoration: InputDecoration(
                        border:  OutlineInputBorder(
    borderSide: BorderSide(
    width: 0, color:Colors.black,)),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
    width: 1, color:Colors.black,)),
    // border: InputBorder
                        contentPadding: EdgeInsets.only(top: 20,left: 10),
                          // prefixIcon: Icon(
                          //   Icons.category,
                          //   color: Color(colour),
                          // ),
                          hintText: 'Product name*',
                          hintStyle:TextStyle(fontSize: 14) ,
                          // enabledBorder: InputBorder.none,
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CONFIRM CURRENT LOCATION',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman'),
                      )),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: CSCPicker(
                          disableCountry: true,
                          // defaultCountry: DefaultCountry.India,
                          flagState: CountryFlag.DISABLE,
                          layout: Layout.vertical,
                          onCountryChanged: (country) {
                            setState(() {
                              selectedCountry = country;
                            });
                          },
                          onStateChanged: (state) {
                            setState(() {
                              selectedState = state;
                            });
                          },
                          stateDropdownLabel: 'Select state',
                          cityDropdownLabel: 'Select city',
                          onCityChanged: (city) {
                            setState(() {
                              selectedCity = city;
                            });
                          }),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(26, 20, 20, 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PRODUCT DETAILS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                            fontSize: 15),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                      textAlign: TextAlign.justify,
                      maxLength: 120,
                      controller: _description,
                      // maxLines: 2,
                      validator: (item) {
                        return item!.length > 0 ? null : 'Name can\'t be empty';
                      },
                      onChanged: (item) {},
                      keyboardType: TextInputType.name,
                      cursorColor: Color(colour),
                      decoration: InputDecoration(
                          border:  OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0, color:Colors.black,)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1, color:Colors.black,)),
                          // border: InputBorder
                          contentPadding: EdgeInsets.only(left: 10,top: 0),
                          // prefixIcon: Icon(
                          //   Icons.category,
                          //   color: Color(colour),
                          // ),
                          hintText: 'Product discription*',
                          hintStyle: TextStyle(fontSize: 15),
                          // enabledBorder: InputBorder.none,
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))),
                    ),
                  ),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 20,
                    ),
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    // child:
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        isExpanded: false,
                        items: product_age
                            .map((value) => DropdownMenuItem(
                                  child: Text('$value'),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (item) {
                          setState(() {
                            selectedAge = item;
                          });
                        },
                        value: selectedAge,
                      ),
                    ),
                  ),
                  selectedAge == 'Old'
                      ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: TextFormField(
                          controller: _years,
                          validator: (item) {
                            return item!.length > 0
                                ? null
                                : 'Name can\'t be empty';
                          },
                          onChanged: (item) {},
                          keyboardType: TextInputType.number,
                          cursorColor: Color(colour),
                          decoration: InputDecoration(
                              border:  OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0, color:Colors.black,)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1, color:Colors.black,)),
                              // border: InputBorder
                              contentPadding: EdgeInsets.only(left: 10,top: 0),
                              // prefixIcon: Icon(
                              //   Icons.category,
                              //   color: Color(colour),
                              // ),
                              hintText: 'How years old*',
                              // enabledBorder: InputBorder.none,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))),
                        ),
                      )
                      : Text(''),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child:
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              loading=true;
                            });
                            if (_formkey.currentState!.validate()) {
                              if (_productImageList.isNotEmpty) {
                                if (locationValidation(selectedState,selectedCity)) {
                                  var fileName = DateTime
                                      .now()
                                      .microsecondsSinceEpoch
                                      .toString();
                                  uploadProductData(_provider, fileName);
                                }
                                else{
                                  setState(() {
                                  loading = false;
                                });
                                  Message(context, 'Please provide valid address');
                                }
                              }
                              else{
                                setState(() {
                                  loading =false;
                                });
                                Message(context, 'Please select atleast 1 image of product');
                              }
                            }
                            else{
                              Message(context, "Please fill required field");
                              setState(() {
                                loading = false;
                              });

                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            // padding: EdgeInsets.only(left: 20, right: 20),
                            child:
                            Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                // gradient: LinearGradient(
                                //     colors: [(Color(0xffF5591E)), Color(0xffF2861E)]),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green),
                          ),
                        ),
                  ),
                  SizedBox(height: 20,)


                ],
              ),
            )));
  }
  Future<void> uploadProductData(CategoryProvider provider,var fileName) async
  {
   DocumentReference documentReference= await FirebaseFirestore.instance.collection('productData').add(
        {
          'category': provider.selectedCategory,
          'subCategory':provider.selectedSubCategory,
          'productName': _product_name.text,
          'country': selectedCountry,
          'state': selectedState,
          'city': selectedCity,
          'year': selectedAge,
          'sellerUid': _services.user!.uid,
          'yearscount':_years.text,
          // 'images':imageUrls
          'description':_description.text,
          'postOn':DateTime.now().microsecondsSinceEpoch,
        });
          String id=documentReference.id;
      _services.productData.doc(fileName).update({'productId':id});
      try{
      uploadMultiImage(_productImageList,id);
      setState(() {
        loading = false;
      });
           Message(context, 'Product uploaded sucessfully');

    }
      catch(onError){
      setState(() {
        loading = false;
      });
      Message(context, onError.toString());
    };

  }

  List<String> product_age = ['New', 'Old'];
}


