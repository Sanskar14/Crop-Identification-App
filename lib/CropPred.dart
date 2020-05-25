import 'package:cropp/Animation/FadeAnimation.dart';
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
import 'package:cropp/Explore.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class MyCrop extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyCrop> {
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
  Future<bool> dialogTriggerP(BuildContext context,String name) async{
            return showDialog(
              context: context,
                 barrierDismissible: false,
                 builder: (BuildContext context){
                   return Dialog(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20.0)
                     ),
                     child: Container(
                       height: 400,
                     child: Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: Column(
                         
                         
                         children: <Widget>[
                          Image.file(_image),
                          SizedBox(height: 50,),
                          SizedBox(height: 30,),
                          Text(name,style:TextStyle(fontSize: 30), ),
                          FlatButton(
                         child: Text('Alright'),
                        textColor:Colors.blue ,
                        onPressed: (){
                          Navigator.of(context).pop(); 
                           },
                       )
                         ],
                       ),
                     ),
                     ),
                   );
                 }
            );
  }
  Future<bool> dialogTriggerPP(BuildContext context) async{
            return showDialog(
              context: context,
                 builder: (BuildContext context){
                   return AssetGiffyDialog(
    image:Image.file(_image),
    title: Text('Men Wearing Jackets',
            style: TextStyle(
            fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
    description: Text('coffee',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
    onOkButtonPressed: () {},
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
                           dialogTriggerPj(context);
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
   appBar: new AppBar(title: Text("Crop"),),
      drawer: new     Drawer(
                                   child: ListView(
                                   children:<Widget>[
                                   new UserAccountsDrawerHeader(
                                   accountName: new Text('Sanskar Gupta'),
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
    MaterialPageRoute(builder: (context) => ExPage()),
  );
                                        
                                    },
                                  ),
                                  ListTile(
                                    title: new Text('CropIdentification'),
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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue[600],
              Colors.blue[400],
              Colors.blue[200],
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                
                  FadeAnimation(1, Text("Crop Identification ", style: TextStyle(color: Colors.white, fontSize: 30),)),
                  SizedBox(height: 10,),
                  FadeAnimation(1.3, Text("Byte Walker", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        FadeAnimation(1.4, Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                        )),
                        SizedBox(height: 10,),
                        FadeAnimation(1.6, Container(
                          child: Center(
                           child:Row( 
                             mainAxisAlignment: MainAxisAlignment.center,
                             children:<Widget>[
                            FloatingActionButton(
                              heroTag: "btn2",
                            onPressed: () {
                                                   getImage(true);
                                      },
                                      child: Icon(Icons.add_a_photo),
                                      backgroundColor: Colors.blue,

                           ),
                           SizedBox(width: 30.0,),
                          FloatingActionButton(
                            heroTag: "btn1",
                            onPressed: () {
                                            getImage(false);
                                      },
                                      child: Icon(Icons.drive_eta),
                                      backgroundColor: Colors.blue,

                           ),
                            ],
                           ),
                          ),
                        )),
                        SizedBox(height: 50,),
                        SizedBox(height: 30,),
                       _image==null? Container():Image.file(_image,height: 300.0,width:300.0,), 
                         FloatingActionButton(
                         elevation: 7.0,
                         child: Icon(Icons.drive_eta),
                         onPressed: (){
                          try{ var random = new Random().nextInt(10000);
                          
                          final uid = inputData();
                          String img_name = 'image_$random.jpg';
                           final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(img_name);
                           final StorageUploadTask task = firebaseStorageRef.put(_image);
                           Future<List> data = makeRequest(img_name);
                         print(_image);
                           }on Exception catch(_){
                             dialogTriggerN(context);
                           }
                         },
                       )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class Crop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue[900],
              Colors.blue[800],
              Colors.blue[400]
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Crop Identification ", style: TextStyle(color: Colors.white, fontSize: 30),)),
                  SizedBox(height: 10,),
                  FadeAnimation(1.3, Text("Byte Walker", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        FadeAnimation(1.4, Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                        )),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        FadeAnimation(1.6, Container(
                          child: Center(
                            child: FloatingActionButton(
                            onPressed: () {
                                                   Navigator.push(
                                                   context,
                                                   MaterialPageRoute(builder: (context) => LoginPage()),
                                                   );
                                      },
                                      child: Icon(Icons.add_a_photo),
                                      backgroundColor: Colors.blue,

                           ),
                            
                            
                          ),
                        )),
                        SizedBox(height: 50,),
                        SizedBox(height: 30,),
                        
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
