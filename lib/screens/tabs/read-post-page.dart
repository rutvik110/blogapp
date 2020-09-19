import 'package:blog_app/screens/tabs/webview.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';
//you can read the post on the screen
class ReadPostPage extends StatefulWidget {
  String name;
  String title;
  String date;
  String picurl;
  String url;
  String content;
  
  ReadPostPage({this.title,this.date,this.picurl,this.url,this.content,this.name});
  @override
  _ReadPostPageState createState() => _ReadPostPageState();
}

class _ReadPostPageState extends State<ReadPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
       child: Row(
         mainAxisSize: MainAxisSize.max,
         
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           ButtonBar(
             buttonPadding: EdgeInsets.symmetric(vertical:5.0),
             alignment: MainAxisAlignment.start,
             children: <Widget>[
               IconButton(icon: Icon(Icons.star), onPressed: (){}),
           IconButton(icon: Icon(Icons.bookmark), onPressed: (){}),
           IconButton(icon: Icon(Icons.share), onPressed: (){}),
             ],
           ),
           Padding(
             padding: EdgeInsets.only(right:10.0),
             child: IconButton(
               alignment: Alignment.centerRight,
               icon: Icon(Icons.cloud_download), onPressed: (){}),
           ),

         ],
       ),
       
      ),
      body: SingleChildScrollView(
              child: Container(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20.0,left:10.0,right:10.0),
                child: Text(widget.title,style: posttitlestyle),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:10.0 ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal:0),
                  leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            widget.picurl
                          )
                        ),
                        title: Text(
                          widget.name +'  '+ widget.date,
                        
                        style: TextStyle(
                          fontSize: 12.0
                        ),
                        ),
                        
                ),
              ),

              Container(
                height: 250.0,
                width: MediaQuery.of(context).size.width,
               
                 child:Image(
                   frameBuilder: (BuildContext context, Widget child, int frame, bool wasSynchronouslyLoaded) {
    return frame!=null ? child :Center(child: CircularProgressIndicator());
  },
                   
                   image: CacheImage(
                        widget.url,
                        cache: true
                        
                        ),fit: BoxFit.cover)
              ),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                  child: Builder(
    builder: (context) {
     if(widget.content.isNotEmpty){
              return RichText(
                  
                  text: HTML.toTextSpan(
                    context,widget.content,
                    overrideStyle: {
                      'p':TextStyle(fontSize:17.0,fontFamily: Theme.of(context).textTheme.caption.fontFamily),
                      'a':TextStyle(fontSize:17.0),
                    },
                    linksCallback: (link){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return WebviewScreen(link:link);
                      }));
                    }
                    )
          );
          } else{
            
            return Container(child:Text('Nothing to show'));
          }
          
               
    },
  ),
                ),
            ],
          ),
        ),
      ),


    );
  }
}











//styles for text will be down here
TextStyle posttitlestyle=TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w500
);