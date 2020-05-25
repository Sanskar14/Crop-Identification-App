import 'package:cropp/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


//********************************************************************************************************************** */
//************************************************************************************************************************* */
//************************************************************************************************************************* */
class LoginPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
 String _pass;
  String _email;
Future<bool> dialogTrigger(BuildContext context) async{
            return showDialog(
              context: context,
                 barrierDismissible: false,
                 builder: (BuildContext context){
                   return AlertDialog(
                     title: Text("Unable to Signin",style:TextStyle(fontSize: 15.00), ),
                     content: Text('May be Bad Formatted Email/Passward or May be this Email is not Registered '),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  FadeAnimation(1, Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 10,),
                  FadeAnimation(1.3, Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Email or Phone number",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    
                                  ),
                                  onChanged: (value){
                                     setState(() {
                                                       _email =value;                     
                                                                          });    
                                                
                                                    
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                  onChanged: (value){
                                     setState(() {
                                          _pass =value;
                                             });
                                                
                                                    
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                        SizedBox(height: 40,),
                        FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Colors.grey),)),
                        SizedBox(height: 40,),
                        FadeAnimation(1.6, Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue[500]
                          ),
                          child: Center(
                            child: RaisedButton(
                            color: Colors.blue[500],  
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            onPressed: () {       FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _email,
                              password: _pass,
                            ).then((AuthResult auth) {
                              Navigator.of(context).pushReplacementNamed('/CropPred');
                            }).catchError((e){
                              print(e);
                              dialogTrigger(context);
                              
                            }); 
                                      },
                           ),
                            
                            
                          ),
                        )),
                        SizedBox(height: 50,),
                        FadeAnimation(1.7, Text("Continue with social media", style: TextStyle(color: Colors.grey),)),
                        SizedBox(height: 30,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeAnimation(1.8, Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue
                                ),
                                child: Center(
                                  child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              )),
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: FadeAnimation(1.9, Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black
                                ),
                                child: Center(
                                  child: Text("Github", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              )),
                            )
                          ],
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