
import 'package:blog_app/screens/tabs/read-post-page.dart';
import 'package:blog_app/server-side.dart/firebase-database.dart';
import 'package:flutter/material.dart';


//using flutters inbuilt search api to build search screen

class Customsearchdelegate extends SearchDelegate {

  
  
  @override
  List<Widget> buildActions(BuildContext context) {
      
      
      return [
        IconButton(icon: Icon(Icons.clear), onPressed: (){
          query='';
        })
      ];
    
    }
  
  @override
  Widget buildLeading(BuildContext context) {
      // TODO: implement buildLeading
      return 
        IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
        });
      
    }
  
   
  @override
  Widget buildResults(BuildContext context) {
      
       return StreamBuilder<List<Articles>>(
      stream: FirebaseDatabase().getsearchresults(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        } 

        else{
          
        final suggestionresults=snapshot.data.where((article) => article.title.toLowerCase().contains(query.toLowerCase()));

          return suggestionresults.length!=0? ListView(
          children: suggestionresults.map(
            (article) => ListTile(
              leading: Icon(Icons.book),
              title: Text(article.title),
            )).toList(),
        ):Center(child: Text('no related posts found'));
     
        }
        
        
       

        
      
        
      });
    }
  
  
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return query.isNotEmpty ?StreamBuilder<List<Articles>>(
      stream: FirebaseDatabase().getsearchresults(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        } 

        final suggestionresults=snapshot.data.where((article) => article.title.toLowerCase().contains(query.toLowerCase()));
        
       

        
      
        return  ListView(
          children: suggestionresults.map(
            (article) => InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){

                  return ReadPostPage(
                    name: article.name,
                    title: article.title,
                    date: article.date,
                    content: article.content,
                    url: article.picurl,
                    picurl: article.url,
                  );
                }));
              },
                          child: ListTile(
                leading: Icon(Icons.book),
                title: Text(article.title),
              ),
            )).toList(),
        );
      }): Center(child: Text('serch for something'),);
  }
  


}