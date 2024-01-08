import 'dart:io';

import '../main.dart';
import '../methods/appconstants.dart';
import '../methods/providerclass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../auth_screens/identityverification.dart';
FirebaseServices services=FirebaseServices();
class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

final picker=ImagePicker();
File ? _image;
class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  bool _uploading=false;
  Future getImage() async
  {
    final pickedFile =await picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
    setState(() {
      if(pickedFile!=null){
        _image=File(pickedFile.path);
      }
      else{
        Message(context, 'No image selected');
        // print('data');
      }
    });
  }
  var _selectedimages=1;
  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<CategoryProvider>(context);

    Future<String> uploadimage() async {
      File? file=File(_image!.path) ;
      String imageName='productsImage/${DateTime.now().microsecondsSinceEpoch}';
      String downloadUrl='';
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl=await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        if(downloadUrl!=null){
          setState(() {
            _image=null;
            _provider.getImageUrl(downloadUrl);
            _provider.getSelectedImages(_selectedimages+1);
            // _selectedimages++;
          });
        }

      }on FirebaseException catch(e){
        Message(context, e.code);
      }
      return downloadUrl;
    }
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Upload images',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(child:_image==null? Icon(CupertinoIcons.photo_on_rectangle):Image.file(_image !,)),
                      color: Colors.grey,
                    ),
                    if(_image!=null)
                      Positioned(right:10,child: IconButton(onPressed: (){
                        if(_image!=null){
                          setState(() {
                            _image=null;
                          });}}, icon: Icon(Icons.clear,color: Colors.black,))),

                  ],
                ),
                SizedBox(height: 20,),
                if(_provider.ImageUrlList.length>0)
                Container(
                    decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.circular(4)), child:GalleryImage( numOfShowImages:_provider.selectedImages,imageUrls: _provider.ImageUrlList,)),
                SizedBox(
                  height: 0,
                ),
                if(_image!=null)
                  Row(children: [Expanded(
                    child: GestureDetector(
                      onTap: (){getImage();},
                      child: Container( alignment:Alignment.center,height:45,width:double.infinity,margin:EdgeInsets.fromLTRB(20, 20, 0, 0),padding: EdgeInsets.only(left: 10,right: 20),child: Text('Cancel'),decoration: BoxDecoration(borderRadius:BorderRadius.circular(5),color:Colors.red,border: Border.all(color: Colors.black)),),
                    ),
                  ), SizedBox(width: 10,),             Expanded(
                    child: GestureDetector(
                      onTap: (){setState(() {
                        _uploading=true;
                        uploadimage().then((url){
                          if(url!=null){
                            setState(() {
                              _uploading=false;
                            });
                          }
                          _provider.getSelectedImages(_selectedimages+1);
                          _selectedimages++;

                        });
                      });;},
                      child: Container( alignment:Alignment.center,height:45,width:double.infinity,margin:EdgeInsets.fromLTRB(0, 20, 20, 0),padding: EdgeInsets.only(left: 10,right: 20),child: Text('Save'),decoration: BoxDecoration(borderRadius:BorderRadius.circular(5),color:Colors.green,border: Border.all(color: Colors.black)),),
                    ),
                  )

                  ],) ,
                SizedBox(height: 20,),
                if(_uploading)
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),
                GestureDetector(
                  onTap: (){getImage();},
                  child: Container( alignment:Alignment.center,height:45,width:double.infinity,margin:EdgeInsets.fromLTRB(20, 20, 20, 20),padding: EdgeInsets.only(left: 10,right: 20),child: Text('Upload image'),decoration: BoxDecoration(borderRadius:BorderRadius.circular(5),color:Colors.grey,border: Border.all(color: Colors.black)),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }



}
Future<XFile?> singleImagePicker() async
{
  return await ImagePicker().pickImage(source:ImageSource.gallery);
}

Future<List<XFile?>> multiImagePicker() async
{
   List<XFile?> _images= await ImagePicker().pickMultiImage();

   if(_images.isNotEmpty){
     return _images;
   }
   return [];
}
List<String> imageUrls=[];
 Future<String> uploadSingleImage(XFile image,var fileName) async
 {
   FirebaseServices _services=FirebaseServices();
   Reference reference=FirebaseStorage.instance.ref('productImages/${services.user!.uid}/${DateTime.now().microsecondsSinceEpoch}');
   UploadTask uploadTask=reference.putFile(File(image!.path));
   uploadTask.snapshotEvents.listen((event) {});
   await uploadTask.whenComplete(() async {
     var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
     imageUrls.add(uploadPath);
     _services.productData.doc(fileName).update({'images':imageUrls});
 });
   return " ";

 }

 Future<List<String>> uploadMultiImage(List<XFile?> list,fileName) async
 {
   List<String> urlList=[];
   for(XFile? _image in list){
     urlList.add(await uploadSingleImage(_image!,fileName));
   }
     return urlList;
 }