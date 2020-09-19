import 'package:blog_app/screens/tabs/read-post-page.dart';
import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Discover_Category extends StatefulWidget {
  final String category;
  Discover_Category({this.category});
  @override
  _Discover_CategoryState createState() => _Discover_CategoryState();
}

class _Discover_CategoryState extends State<Discover_Category> {



  Stream getcategorypost(String category){
    return Firestore.instance.collectionGroup('blog-posts').where('category',isEqualTo:category).orderBy('created',descending: true).getDocuments().asStream();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category}'),
      ),
      
      body: StreamBuilder<dynamic>(
        stream: getcategorypost(widget.category),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){

              if(snapshot.hasData){
                
                 return snapshot.data.documents.length!=0 ?ListView.builder(
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
                    height: 130.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      
                      image: DecorationImage(image: AssetImage(
                        'assets/images/hacker-image.jpg',
                        
                      ),
                      fit: BoxFit.fitHeight)
                    ),
                    child:Image(
                      
                      image: CacheImage(
                      snapshot.data.documents[index]['post-image-url'],
                      cache: true
                      
                      ),fit: BoxFit.cover)
                      
                      ),
                ),
            );
                }):Center(child: Text('No Posts to show for now:('),);
                
                }

                else{
                 
                  return Text('No Posts to show for now:(');
                }
            
            
          }

          

          return Center(child: CircularProgressIndicator());
        }),
    );
  }
}