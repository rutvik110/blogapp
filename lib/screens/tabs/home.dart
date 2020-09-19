import 'package:blog_app/screens/tabs/discover.dart';
import 'package:blog_app/screens/tabs/homestream.dart';
import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:flutter/material.dart';
import 'package:scroll_bottom_navigation_bar/scroll_bottom_navigation_bar.dart';
import 'dart:io';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import '../search.dart';


//home page has two tabs-homestream and discover tab
//homestream shows the main feed in the tab and has stream which loads the post docs to shown in feed.
//discover tab is the place where you can choose specific category to see posts related to it.
//controller for appbar,bottomnavigation bar in Home and listview builder in homestream which shows posts.


final controlleral=ScrollController();
class Home extends StatefulWidget {
  final User user;
  final   String htmlContent;
  Home({this.htmlContent,this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  

  int pageindex=0;
  
  List<dynamic> postcontent;
  
  File jsonfile;
  final homescaffoldState = GlobalKey<ScaffoldState>();
  final controllerappbar=controlleral;
  /*
  getfile()async{
    final content=await File(Directory.systemTemp.path + "/quick_start.json");
    final file= await content.readAsString();
    final post=await jsonDecode(file);
    print(post.toString());
    setState(() {
        _notusDocument=NotusDocument.fromJson(post);
        
      });
 
  }

  */
  /*
  loaddocument()async{
   final directory = await getApplicationDocumentsDirectory();
   final  content=await File('${directory.path}/post.json');
   if(await content.exists()){
        final files=await content.readAsString();
      final post=await jsonDecode(files);
      setState(() {
        print(post);
        htmlContent=post['content'];
        print(htmlContent);
      });
   }
   
  }*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    
     
  }

  
  
 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
        drawer: Drawer(
          child: SafeArea(
            
            child: Container(
              padding: EdgeInsets.only(left:10.0,top:5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(widget.user.user.photoUrl),
                  ),
                 
                  Text(widget.user.user.displayName),
                  Text(widget.user.user.email),
                  FlatButton.icon(
                    onPressed: (){
                      
                      FirebaseDatabase().signout();
                    },
                     icon:Icon(Icons.all_out),
                      label: Text('Sing out'))

                  
                ],
              ),
            )),
        ),
      appBar: ScrollAppBar(
        controller: controllerappbar,
        elevation: 0,
        title:Text('Blog App'),
        centerTitle: true,
        
        
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed:(){
            //loaddocument();
            showSearch(
              context: context,
               delegate: Customsearchdelegate());
          })
        ],
      ),

      bottomNavigationBar: ScrollBottomNavigationBar(
        controller: controlleral,
        
        
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:Icon(Icons.home),
            title: Text('Home')),
            BottomNavigationBarItem(
              
            icon:Icon(Icons.motorcycle),
            title: Text(
                'Discover'
              ) ),

        ]),

      body:ValueListenableBuilder<int>(
        
        valueListenable: controlleral.bottomNavigationBar.tabNotifier,
        builder:(context,index,child){
           
           return index==0?Homestream(widget: widget, htmlContent: widget.htmlContent):Discover();
        } ,)
    );
  }
}



