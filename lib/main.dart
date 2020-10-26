

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:blog_app/wrapper.dart';


void main() {
  
  
  runApp(
   
    Myapp()
    
    );
}

class Myapp extends StatelessWidget {
   final du = 0;
  @override
  Widget build(BuildContext context) {
    //streamprovider listens to the user stream
    return StreamProvider<User>.value(
      value: FirebaseDatabase().user,
      child: MaterialApp(
        
        debugShowCheckedModeBanner: false,
        
        home:Wrapper(),
      ),
    );
  }
}