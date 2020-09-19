import 'dart:async';

import 'package:blog_app/screens/tabs/read-post-page.dart';
import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import '../editorcreatepost.dart';
import 'home.dart';


class Homestream extends StatefulWidget {
  const Homestream({
    Key key,
    @required this.widget,
    @required this.htmlContent,
  }) : super(key: key);

  final Home widget;
  final String htmlContent;

  @override
  _HomestreamState createState() => _HomestreamState();
}

class _HomestreamState extends State<Homestream> {
  

  Future<void> _handlerefresh()async{
    final Completer<void> completer=Completer<void>();
    Timer(Duration(seconds: 2), (){
      completer.complete();
      print('futute completed');
    });
    setState(() {
      
    });
    print('waiting');
    return completer.future.then<void>((_) => 
      print('returned future')
    );
    
  }

  @override
  void initState() {
    super.initState();
    
  }
   
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
    floatingActionButton: FloatingActionButton(
        onPressed:()async {
          //final  picker=ImagePicker();
          //final  image=await picker.getImage(source: ImageSource.gallery);

          //await FirebaseDatabase().uploadimage(image.path,widget.user);
          
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return CreateOrEdit(user:widget.widget.user);
          }));
          
        },
        child: Icon(Icons.add),),
          body: StreamBuilder<dynamic>(
        
        stream: FirebaseDatabase().getblogposts(),
        builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.done){

              if(snapshot.hasError){
                return Center(child: Text('no connection'));
              }
              
              
              return RefreshIndicator(
                onRefresh: _handlerefresh,
                
                              child: ListView.builder(
                                
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controlleral,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,index){
                  return Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical:5.0),
                 
                  child: ListTile(
                    
                    contentPadding: EdgeInsets.symmetric(vertical:10.0,horizontal: 15.0),
                      enabled: true,
                      onTap: (){
          
          Navigator.push(context, MaterialPageRoute(builder: (context){

            return ReadPostPage(
                name:snapshot.data.documents[index]['name'],
                title:snapshot.data.documents[index]['title'],
                date:snapshot.data.documents[index]['created-on'],
                picurl:snapshot.data.documents[index]['user-image-url'] ,
                url:snapshot.data.documents[index]['post-image-url'],
                content:snapshot.data.documents[index]['content']

            );

          }));
                      },
                      /*leading: CircleAvatar(
          backgroundImage: NetworkImage(
            widget.user.user.photoUrl
          )
                      ),*/
                      title: Padding(
          padding: const EdgeInsets.only(bottom:6.0),
          child: Text(
            snapshot.data.documents[index]['title'],

            style: TextStyle(
                fontSize: 20.0
            ),
            ),
                      ),
                      subtitle: Padding(
          padding: const EdgeInsets.only(top:6.0),
          child: Text(
            snapshot.data.documents[index]['name'] +'    '+snapshot.data.documents[index]['created-on'],
             style: TextStyle(
                fontSize: 12.0
            ),),
                      ),

                      trailing: Container(
          width: 80.0,
          height: 100.0,
          
          decoration: BoxDecoration(
            
            image: DecorationImage(image: AssetImage(
                'assets/images/hacker-image.jpg',
                
            ),
            )
          ),
          child:Image(
            
            image: CacheImage(
            snapshot.data.documents[index]['post-image-url'],
            cache: true
            
            ),fit: BoxFit.fitWidth)
            
            ),
                    ),
                );
                },
            ),
              );
            }

            

            

            

            return Center(child: CircularProgressIndicator());
            
            
        }
      ),
    );
  }
}

