import 'package:blog_app/screens/post_create.dart';
import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CreateOrEdit extends StatefulWidget {
  final User user;
  CreateOrEdit({this.user});
  @override
  _CreateOrEditState createState() => _CreateOrEditState();
}

class _CreateOrEditState extends State<CreateOrEdit> {

  TextEditingController _textEditingController=TextEditingController();

  String image_path;
  
  final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: ()async{
                return showDialog(
                  
                  context: context,
                  builder: (context){
                    List<String> categories=[
                      'Work','Programming','Android Dev','Education','Technology',
                      'Business','Science','Psychology','Health','World','Food',
                      'Art','Travel','Gaming','Space','Comedy','Politics','Sports',
                      'Music','Economy','Startups','IOS DEV','Freelancing','Lifestyle'];
                    String dropdown_value;
                    return SimpleDialog(
                      children: <Widget>[
                      StatefulBuilder(
                        builder: (BuildContext context,StateSetter setState){
                          return   
                                Container(
                                padding: EdgeInsets.symmetric(horizontal:20.0,vertical:20.0),
                                child: Form(
                                  key: _formkey,
                                   child: Column(
                                    children: <Widget>[
                                  TextFormField(
                                    controller: _textEditingController,
                                    validator:(value)=> _textEditingController.text.isEmpty?'Enter a valid title':null ,
                                    decoration: InputDecoration(
                                      hintText: 'Enter title',
                                      
                                      labelText: 'Title'
                                    ),
                              ),
                              DropdownButtonFormField(
                                
                                  validator:(value)=> value.isEmpty?'Enter a valid title':null ,
                                  hint: Text('Select category'),
                                  value: dropdown_value,
                                  onChanged: (value){
                                    setState(() {
                                      dropdown_value=value;
                                      print(value);
                                    });
                                    
                                  },
                                    
                                  items:categories.map((option) => 
                                  
                                  DropdownMenuItem(
                                    
                                      child: Text(option),
                                      value: option,
                                      onTap: (){
                                        setState(() {
                                          
                                        });
                                      },
                                      )
                                  
                                  ).toList()
                              ),
                             

                              FlatButton.icon(onPressed:()async{
                                      final  picker=ImagePicker();
                                      final  image=await picker.getImage(source: ImageSource.gallery).then((value) => 
                                        
                                        setState((){
                                           image_path=value.path;
                                        })
                                       
                                      
                                      );
                                    }, icon: Icon(
                                      Icons.picture_in_picture,
                                      color: image_path!=null?Colors.blue:Colors.black,), label: Text('Pick photo')
                              
                              ),

                              ButtonBar(
                                    alignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                  FlatButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                     child: Text('Cancel')),

                                  FlatButton(
                                    onPressed: (){
                                      if(_formkey.currentState.validate() ){
                                         Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                        return PostEditor(isnew: true,user:widget.user,imagepath: image_path,title: _textEditingController.text,category:dropdown_value);
              }
              )
              );
                                      }
                                       
                                    },
                                     child: Text('Create'))  

                                    ],
                              )
                            ],
                          ),
                                ),
                      );
                      }
                       ),]
                    );
                  }
                  );
                  
               /* final directory = await getApplicationDocumentsDirectory();
                final  content=await File('${directory.path}/post.json');
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                  return PostEditor(isnew: true,user:widget.user);
              }
              )
              );
                */
              },
               icon: Icon(Icons.add),
                label: Text('Create new post')),


            FlatButton.icon(
              onPressed: ()async{
                final directory = await getApplicationDocumentsDirectory();
                final  content=await File('${directory.path}/${widget.user.user.email}.json');
                if(await content.exists()){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                  return PostEditor(isnew: false,user:widget.user,imagepath: image_path,title: _textEditingController.text,);
              }));
                }
                else{
                  return print('no existing post');
                }
              },
               icon: Icon(Icons.edit),
                label: Text('Edit existing one')),


          ],
        ),
      ),
    );
  }
}