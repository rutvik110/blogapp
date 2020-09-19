import 'dart:io';
import 'dart:ui';
import 'package:blog_app/screens/uploading-post-screen.dart';
import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // access to jsonEncode()
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:path_provider/path_provider.dart';

class PostEditor extends StatefulWidget {

  final bool isnew;
  final User user;
  final String category;
  final String imagepath;
  final String title;
  PostEditor({this.isnew,this.user,this.category,this.imagepath,this.title});


  @override
  _PostEditorState createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  
  

  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  //global key for html editor
  
  
  final _scaffoldState = GlobalKey<ScaffoldState>();
  String  htmlContent='';
  String title='';
  @override
  void initState() {
    super.initState();
    // loading the exsiting document to show in editor
    loaddocument();
    
    
  }

  loaddocument()async{
    
   final directory = await getApplicationDocumentsDirectory();
   final  content=await File('${directory.path}/${widget.user.user.email}.json');
   if(await content.exists()){
        final files=await content.readAsString();
      final post=await jsonDecode(files);
      setState(() { 
        
        
          htmlContent=post['content'].toString();
          title=post['title'].toString();
          
        
        
      });
   }
   
  }
  
  
  


  @override
  Widget build(BuildContext context) {
    
  
    return Scaffold(
    key: _scaffoldState,
    appBar: AppBar(
      actions: <Widget>[
        FlatButton(
    color: Colors.white,
    onPressed: ()async{
            
            if(widget.isnew){
                

                  
                 final value = await _keyEditor.currentState.getText().then((value)async{
                    
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return Uploadingpost(
                      title: widget.title,
                      content: value.toString(),
                      user: widget.user,
                      imagepath: widget.imagepath,
                      category: widget.category,
                    );
                  }));
                    //getting directory path
                  
                    /*final directory = await getApplicationDocumentsDirectory();
                    Map<String,dynamic>  postmap={
                      'title':widget.title,
                      'content':value.toString(),
                      
                    };

                    final contents = jsonEncode(postmap);
                    final file= File('${directory.path}/${widget.user.user.email}.json');
                    file.writeAsString(contents).then((value) => print(''));
                    String imageurl=await FirebaseDatabase().uploadimage(widget.imagepath,widget.user, widget.title);
                    
                    
                    await FirebaseDatabase().adduserspost(widget.user, postmap,imageurl,widget.category);
                    
                    
                    await FirebaseDatabase().updateuserspost(widget.user, postmap);
                    
                    
                    
                    Navigator.pop(context);*/
                    
                  }
                            );
                            
            }

            else{

              final value = await _keyEditor.currentState.getText().then((value)async{
                    //getting directory path
                    final directory = await getApplicationDocumentsDirectory();
                    Map<String,dynamic>  postmap={
                      'title':title,
                      'content':value.toString(),
                      
                    };

                    final contents = jsonEncode(postmap);
                    final file= File('${directory.path}/${widget.user.user.email}.json');
                    file.writeAsString(contents).then((value) => print(''));
                    
                    await FirebaseDatabase().updateuserspost(widget.user, postmap);
                    
                    Navigator.pop(context);
                  }
                            ); 

            }
          

    }, child: Text(
          widget.isnew?'Submit':'Update',
          
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue
            
          ),
    ))
      ],
      centerTitle: true,
      title: Text('App',style: TextStyle(
        color: Colors.white
      ),),
    ),
    body: Form(
        
        child: 
           FlutterSummernote(
          
        customToolbar: """
          [

      ['style', ['bold', 'italic', 'underline']],
      ['font', ['strikethrough', 'superscript', 'subscript']],
       
       ['height',['height']],
       
        ['insert',['link']]
          ]""",
        key: _keyEditor,
        value:widget.isnew?'':htmlContent,
        hint: widget.isnew?'Write here':'',
           
          )
          
        )
        );
  }
}
/*
  Future<NotusDocument> _loadDocument() async{
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final file=File(Directory.systemTemp.path + "/quick_start.json");
    if(await file.exists()){
      final contents=await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }

    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }
}*/
/*
  class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  final picker = ImagePicker();
  
  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await picker.getImage(source: source);
    if (file == null) return null;
    print(file.toString());
   
    return file.toString();
  }
  
  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));
    
    final image = FileImage(file);
    return Image(image: image);
  }
  
}
*/
