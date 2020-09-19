import 'dart:async';

import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:flutter/material.dart';
import 'dart:io';



import 'dart:convert'; // access to jsonEncode()

import 'package:path_provider/path_provider.dart';


class Uploadingpost extends StatefulWidget {
    String imagepath;
    User user;
    String content;
    String title;
    Map<String,dynamic> postmap;
    String imageurl;
    String category;

    Uploadingpost({this.content,this.imagepath,this.user,this.title,this.postmap,this.imageurl,this.category});
  @override
  _UploadingpostState createState() => _UploadingpostState();
}

class _UploadingpostState extends State<Uploadingpost> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadpost();
    
  }

  uploadpost()async{
    //getting directory path
                  
                    final directory = await getApplicationDocumentsDirectory();
                    Map<String,dynamic>  postmap={
                      'title':widget.title,
                      'content':widget.content,
                      
                    };

                    final contents = jsonEncode(postmap);
                    final file= File('${directory.path}/${widget.user.user.email}.json');
                    file.writeAsString(contents).then((value) => print(''));
                    String imageurl=await FirebaseDatabase().uploadimage(widget.imagepath,widget.user, widget.title);
                    
                    
                    await FirebaseDatabase().adduserspost(widget.user, postmap,imageurl,widget.category);
                    
                    
                    await FirebaseDatabase().updateuserspost(widget.user, postmap);
                    
                    
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      return null;
                    }
                    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                
              ),
              Text('Your post is being uploaded...')
            ],
          ),
        ),
      ),
    );
  }
}