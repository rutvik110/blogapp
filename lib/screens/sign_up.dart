import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //to detemine whether to show sign up button or loading indicator.
  bool loading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  void googlesignin()async {
    setState(() {
      loading=true;
    });
    
    dynamic user=await FirebaseDatabase().signupwithgoogle();
    
    
    if(user==null){
      setState(() {
        loading=false;
      });
      print('user not found');
    } 
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: loading ?CircularProgressIndicator():FlatButton.icon(
          onPressed:(){
            
              googlesignin();
            
            
          },
           icon: Icon(Icons.add),
            label:Text('Sign up with your google account')),
      ),
    );
  }
}