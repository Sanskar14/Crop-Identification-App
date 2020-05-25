import 'package:cropp/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:cropp/CropPred.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cropp/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ExPage extends StatefulWidget {
  @override
  _ExState createState() => _ExState();
}

class _ExState extends State<ExPage> {
   File _image;
  File _profile;
  String json;
  String downProfileUrl = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fshort-biography.com%2Femraan-hashmi.htm&psig=AOvVaw10EqxITPEYBv4fewiw009b&ust=1584188130086000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKjKnt-2l-gCFQAAAAAdAAAAABAD";
  Future getImage(bool isCamera) async{
    File image;
    if(isCamera){
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    else{
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
          _image=image;
        });
  }
  
   Future getProfile(bool isCamera) async{
    File image;
    if(isCamera){
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    else{
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
          _profile=image;
        });
  }
  String url = 'http://192.168.43.210:5000/home/image_8562.jpg';
 
  List result;
  var jsoni;
  var body;
  
  Future<List> makeRequest(String name) async{
    var response = await http.get( 'http://192.168.43.210:5000/home/image_8562.jpg');
    print(response.body);
    body=response.body;
    List data;
    var extractdata = jsonDecode(response.body);
    var jsoni = extractdata;
    data = extractdata['results'];
    print(data);
    setState(() {
          result=data;
        });    
   return data; 
  }
//   _makeGetRequest(String name) async {
//   // make GET request
//   String url = 'http://127.0.0.1:5000/home/'+name;
//   Response response = await get(url);
//   // sample info available in response
//   int statusCode = response.statusCode;
//   print(statusCode);
//   Map<String, String> headers = response.headers;
//   String contentType = headers['content-type'];
//   json = jsonEncode(response.body);
//   print(json);
//   // TODO convert json to object...
// }
  Future<bool> dialogTriggerPj(BuildContext context) async{
            return showDialog(
              context: context,
                 barrierDismissible: false,
                 builder: (BuildContext context){
                   return AlertDialog(
                     title: Text("Upload Success",style:TextStyle(fontSize: 15.00), ),
                     content: Text("Uploaded"),
                     actions: <Widget>[
                       FlatButton(
                         child: Text('Alright'),
                        textColor:Colors.blue ,
                        onPressed: (){
                          Navigator.of(context).pop(); 
                           },
                       )
                     ],
                   );
                 }
            );
  }
  Future<bool> dialogTriggerP(BuildContext context) async{
            return showDialog(
              context: context,
                 barrierDismissible: false,
                 builder: (BuildContext context){
                   return AlertDialog(
                     title: Text("Upload Success",style:TextStyle(fontSize: 15.00), ),
                     content: Text("Uploaded"),
                     actions: <Widget>[
                       FlatButton(
                         child: Text('Alright'),
                        textColor:Colors.blue ,
                        onPressed: (){
                          Navigator.of(context).pop(); 
                           },
                       )
                     ],
                   );
                 }
            );
  }
   Future<bool> dialogTriggerN(BuildContext context) async{
            return showDialog(
              context: context,
                 barrierDismissible: false,
                 builder: (BuildContext context){
                   return AlertDialog(
                     title: Text("Upload Failiure",style:TextStyle(fontSize: 15.00), ),
                     content: Text('Your Image Upload Is Unsuccessfull'),
                     actions: <Widget>[
                       FlatButton(
                         child: Text('Alright'),
                        textColor:Colors.blue ,
                        onPressed: (){
                          Navigator.of(context).pop(); 
                           },
                       )
                     ],
                   );
                 }
            );
  }
  Future<bool> dialogTriggerProfile(BuildContext context) async{
            return showDialog(
              context: context,
                 barrierDismissible: false,
                 builder: (BuildContext context){
                   return AlertDialog(
                     title: Text("Upload Profile Picture",style:TextStyle(fontSize: 15.00), ),
                     actions: <Widget>[
                       FlatButton(
                         child: Text('Capture Image'),
                        textColor:Colors.blue ,
                        onPressed: (){
                               getProfile(true);
                           },
                       ),
                        FlatButton(
                         child: Text('Select Image'),
                        textColor:Colors.blue ,
                        onPressed: (){
                               getProfile(false);
                           },
                       ),
                       
                       FlatButton(
                         child: Text('Set Image'),
                        textColor:Colors.blue ,
                         onPressed: (){
                          try{
                              handleUpdateUserProfile();                       
                           dialogTriggerP(context);
                           }on Exception catch(_){
                             dialogTriggerN(context);
                           }
                         },
                       ),
                       FlatButton(
                         child: Text('Alright'),
                        textColor:Colors.blue ,
                        onPressed: (){
                          Navigator.of(context).pop(); 
                           },
                       )
                     ],
                   );
                 }
            );
  }
  
  void handleUpdateUserProfile() async{
    String mediaUrl = await handleUploadImage(_profile); // Pass your file variable 
    // Create/Update firesotre document
    final String uid = await inputData();
    Firestore.instance.collection('profile').document(uid).updateData(
    {
        "avatar": mediaUrl,
    }
    );
   
    setState((){downProfileUrl = mediaUrl;});
    
}
void eUserProfile() async{
 DatabaseReference db = FirebaseDatabase.instance.reference().child('User').child('DP');
 db.once().then((DataSnapshot snapshot){
  Map<dynamic, dynamic> values = snapshot.value;
     values.forEach((key,values) {
      setState(() {
              downProfileUrl = values['DP'];
            });
    });
 });    
    
}
  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
  return uid;
  }
Future<String> handleUploadImage(imageFile) async {
var random = new Random().nextInt(100);
final String uid = await inputData();
StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child("${uid}_profilePic_$random.jpg").putFile(imageFile);
StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
// Once the image is uploaded to firebase get the download link.
String downlaodUrl = await storageTaskSnapshot.ref.getDownloadURL();
return downlaodUrl;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Explore"),),
      drawer: new     Drawer(
                                   child: ListView(
                                   children:<Widget>[
                                   new UserAccountsDrawerHeader(
                                   accountName: new Text('Sanskar'),
                                   accountEmail: new Text('guptasanskar14@gmail.com'),
                                   currentAccountPicture: new CircleAvatar(
                                   backgroundImage: new NetworkImage(downProfileUrl.toString()),
                                    ),
                                  ),
                                  ListTile(
                                    title: new Text('Update Profile Picture'),
                                    onTap: (){
                                        dialogTriggerProfile(context);
                                        _profile==null? Container():Image.file(_image,height: 100.0,width:100.0,);
                                    },
                                    
                                  ),
                                  ListTile(
                                    title: new Text('Explore'),
                                    onTap: (){
                                        
                                          Navigator.push(
                                             context,
                                              MaterialPageRoute(builder: (context) =>new ExPage()));
                                        
                                    },
                                  ),
                                  ListTile(
                                    title: new Text('Crop Identification'),
                                    onTap: (){
                                        
                                          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyCrop()),
  );
                                    },
                                  ),
                                  ListTile(
                                    title: new Text('Logout'),
                                    onTap: (){
                                        FirebaseAuth.instance.signOut().then((value){
                                          Navigator
                                          .of(context).pushReplacementNamed('/signup');
                                        }).catchError((e){
                                          print(e);
                                        });
                                    },
                                  )
                                  ]
                                 )
                               ),  
   
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Explore/back.jpg'),
                  fit: BoxFit.cover
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.2),
                    ]
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FadeAnimation(1, Text("What you would like to find?", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),)),
                    SizedBox(height: 30,),
                    FadeAnimation(1.3, Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey,),
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                          hintText: "Search for crop,plants ..."
                        ),
                      ),
                    )),
                    SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Crops", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 20),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.4, Container(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        makeItem(image: 'assets/Explore/Carrot.jpg', title: 'Carrot'),
                        makeItem(image: 'assets/Explore/coffee1.jpg', title: 'Coffee'),
                        makeItem(image: 'assets/Explore/kesar1.jpg', title: 'Saffron'),
                        makeItem(image: 'assets/Explore/Maize.jpg', title: 'Maize')
                      ],
                    ),
                  )),

                  SizedBox(height: 20,),
                  FadeAnimation(1, Text("Plants", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 20),)),
                  SizedBox(height: 20,),                
                  FadeAnimation(1.4, Container(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                         makeItem(image: 'assets/Explore/CROOT.jpg', title: 'Carrot'),
                        makeItem(image: 'assets/Explore/coffee2.jpg', title: 'Coffee'),
                        makeItem(image: 'assets/Explore/kesar2.jpg', title: 'Saffron'),
                        makeItem(image: 'assets/Explore/Maize-Farming.jpg', title: 'Maize')
                      ],
                    ),
                  )),
                  SizedBox(height: 80,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeItem({image, title}) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover
          )
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.2),
              ]
            )
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
        ),
      ),
    );
  }
}