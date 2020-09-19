
import 'package:blog_app/screens/tabs/home.dart';
import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/sign_up.dart';
//bsed on the value recieved from main.dart streamprovider ,it will redirect user to sign in or home page.
class Wrapper extends StatefulWidget {

  
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  
  @override
  Widget build(BuildContext context) {
    
    final user=Provider.of<User>(context);

    
    

    if(user==null){
      return SignUp();
    }
    else{
      return Home(user: user,); 
    }
  }
}


