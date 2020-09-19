

import 'package:blog_app/screens/tabs/discover-category.dart';
import 'package:flutter/material.dart';


class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {

  ScrollController _controller;
  
  List<String> categories=[
                      'Work','Programming','Android Dev','Education','Technology',
                      'Business','Science','Psychology','Health','World','Food',
                      'Art','Travel','Gaming','Space','Comedy','Politics','Sports',
                      'Music','Economy','Startups','IOS DEV','Freelancing','Lifestyle'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=ScrollController();
  
  }

  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: ListView(
          controller: _controller,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
      Container(
            child: Wrap(
      children: categories.map((chip) => 
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return Discover_Category(category: chip,);
            }));
          },
                    child: Chip(
            
            label: Text(chip)),
        ),
      )
      ).toList()
      ),
          ),]
        ),
    );
  }
}