

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
//user model for provider checking
class User {

 final  FirebaseUser user;
 User({this.user});
}
class FirebaseDatabase {
  //authentication into app start 
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //checking user status
  User _firebaseuser(FirebaseUser user) {

    return user !=null ? User(user: user) :null;

  }

  //stream to check user sign in status
  Stream<User> get user {

    return _firebaseAuth.onAuthStateChanged.map(_firebaseuser);//user object or null value
    
  }

  Future signupwithgoogle()async {
    
    
       
        GoogleSignInAccount googleSignInAccount=await _googleSignIn.signIn().catchError((onError) {
          print("Error $onError");
        });
          if(googleSignInAccount!=null){
            GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
          // get the credentials to (access / id token)
          // to sign in via Firebase Authentication 

          AuthCredential authCredential= GoogleAuthProvider.getCredential(
                                            idToken: googleSignInAuthentication.idToken,
                                            accessToken: googleSignInAuthentication.accessToken);

          FirebaseUser user=(await _firebaseAuth.signInWithCredential(authCredential)).user;
          await FirebaseDatabase().createuserdoc(user);
          
          return _firebaseuser(user);
        }
        
        return null;
        
    
    

  }

  signout()async {
    _googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }

  //authentication into app end




  //STORING Images,Files To DATABASE

   uploadimage(String path,User user,String title, )async{
      //storing images,files to database
      
      FirebaseStorage storage = FirebaseStorage.instance;

      // Create a storage reference from our app
      StorageReference storageRef = storage.ref();

      // Create a child reference
    // imagesRef now points to "images"
      StorageReference imagesRef = storageRef.child("images");

    //creating reference for users images folder
    StorageReference userimagesfolderref=imagesRef.child(user.user.email);
      // Child references can also take paths
      // spaceRef now points to "images/space.jpg
      // imagesRef still points to "images"
      //StorageReference spaceRef = storageRef.child("images/space.jpg"); or
      //StorageReference spaceRef = imagesRef.child("space.jpg")
     
      StorageReference blogpostimageRef = userimagesfolderref.child("$title.jpg");
      final file=await File(path);
      final StorageUploadTask uploadimage=blogpostimageRef.putFile(
        file,
        StorageMetadata(
        contentType: 'image',
        customMetadata: {
          'name':'$title',
          'date_added':DateTimeFormat.format(DateTime.now(),format: 'F d,Y,h i s')
        }
      ),
        );
    
        /* uploadimage.onComplete.then((value) => 
              value.ref.getDownloadURL().then((value) => 
          
                value.toString()
          )
          );*/

      return  uploadimage.onComplete.then((value) => 
                value.ref.getDownloadURL().then((value) => 
                  value.toString()
              )
              );

  }

  CollectionReference _usersdocs=Firestore.instance.collection('usersdata');
  //creating user doc in userdocs collection//this function will be called when user first sign in
  Future createuserdoc(FirebaseUser user)async{

    return await _usersdocs.document(user.email).setData({

      'name':user.displayName,
      'email':user.email,
      'created':DateTimeFormat.format(DateTime.now(),format: 'F d,Y,h i s'),

    });
  }


  //adding new post to posts collection//this function will be called when user wants to add new post
  Future adduserspost(User user,Map post,String imageurl,String category)async{

    return await _usersdocs.document(user.user.email).collection('blog-posts').document(post['title']).setData({
      'name':user.user.displayName,
      'title':post['title'],
      'category':category,
      'content':post['content'],
      'post-image-url':imageurl,
      'user-image-url':user.user.photoUrl,
      'created-on':DateTimeFormat.format(DateTime.now(),format: 'M d,Y'),
      'created':DateTime.now(),
      

    });
  }

   //update users post to posts collection//this function will be called when user wants to update new post
  Future updateuserspost(User user,Map post)async{

    return await _usersdocs.document(user.user.email).collection('blog-posts').document(post['title']).updateData({

      'content':post['content'],


    });
  }

  Stream getblogposts(){

 
    return  Firestore.instance.collectionGroup('blog-posts').orderBy('created',descending:true ).getDocuments().asStream();

  }
  //getting a stream of list of articles from firebase to show in search suggestions section
  Stream<List<Articles>> getsearchresults(){
    final results=Firestore.instance.collectionGroup('blog-posts').orderBy('created',descending:true );
    return results.getDocuments().asStream().map(resultlist);
  }

  //creating the list
  List<Articles> resultlist(QuerySnapshot snapshot){
    return snapshot.documents.map((documents) => 

      Articles(
        name: documents.data['name'],
        title: documents.data['title'],
        date: documents.data['created-on'],
        content: documents.data['content'],
        picurl: documents.data['post-image-url'],
        url:  documents.data['user-image-url'],
        


      )
    
    ).toList();
  }
 
}

//model class used for articles list
class Articles {
    String name;
    String title;
    String date;
    String content;
    String picurl;
    String url;
    Articles({this.title,this.name,this.date,this.content,this.picurl,this.url});
  }