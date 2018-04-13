import 'package:flutter/material.dart';
import 'dart:async';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import './Feed.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    routes: <String, WidgetBuilder>{
      "/PinnedPage": (BuildContext context) => new PinnedPage(),
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'WstApp', home: new FeedPage());
  }
}

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  static FutureBuilder<Feed> _feeder() {
    return new FutureBuilder<Feed>(
      future: fetchFeed().timeout(new Duration(seconds: 15)),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return new Center(child: new LinearProgressIndicator());
            break;
          case ConnectionState.waiting:
            return new Padding(
                child: new Center(child: new LinearProgressIndicator()),
                padding: new EdgeInsets.only(top: 0.0, bottom: 0.0));
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              return new Column(
                children: snapshot.data.items,
              );
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            break;
          default:
            return new Text("ERROR OR SOMETHING");
            break;
        }
      },
    );
  }

  var _newsItems = _feeder();

  Future<Null> _onRefresh() async {
    var fresh = _feeder();
    setState(() {
      _newsItems = fresh;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 191, 216, 239),
        bottomNavigationBar: new BottomNavigationBar(
          fixedColor:  new Color.fromARGB(255, 101, 170, 215),
          items: [ 
            new BottomNavigationBarItem(
                 icon: new Icon(Icons.home),
                 title: new Text("Home"), 
                 backgroundColor: Colors.redAccent
                
        ),

        new BottomNavigationBarItem(
                 icon: new Icon(Icons.search),
                 title: new Text("Explore"),
                 backgroundColor: Colors.black
                
        ), 
        new BottomNavigationBarItem(
                 icon: new Icon(Icons.favorite_border),
                 title: new Text("Saved"),
                 backgroundColor: Colors.black
                
        ), 

        ], 
        ),
        appBar: new AppBar(
          primary: true,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pushNamed("/PinnedPage"),
            )
          ],
          elevation: 2.0,
          centerTitle: true,
          title: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Image.asset(
                'imageAssets/appbar-logo-01.png',
                scale: 1.0,
                fit: BoxFit.fitHeight,
                color: Colors.white,
              )),
          backgroundColor:
             new Color.fromARGB(255, 101, 170, 215),
             
        ),
        body: new RefreshIndicator(
          onRefresh: _onRefresh,
          child: new ListView(
            children: <Widget>[
                
               new Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
                        
                    ),
                    child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child:
                    new TextField(decoration: new InputDecoration.collapsed(hintText: "Search",),),
                    ),
                  ),
                ),

              _newsItems,
            ],
          ),
          color: Colors.black,
        ));
  }
}

class PinnedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: .0,
        centerTitle: true,
        title: new Text("Pinned"),
      ),
    );
  }
}

class NewsCard extends StatefulWidget {
  final _header;
  final _body;
  final _timestamp;

  NewsCard(this._header, this._body, this._timestamp);

  @override
  createState() => new NewsCardState();
}

class NewsCardState extends State<NewsCard> {
  TextStyle _titleStyle = new TextStyle(
    fontSize: 20.0,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontFamily: 'Pragmatica'
  );
  TextStyle _bodyStyle = new TextStyle(fontSize: 14.0, color: Colors.grey);

  TextStyle _timestampStyle = new TextStyle(
    fontSize: 9.0,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 4.0, bottom: 4.0),
      child: new Card(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 5.0, top: 8.0),
              child: new Text(
                widget._timestamp ,
                style: _timestampStyle,
                textAlign: TextAlign.right,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 0.0, bottom: 26.0),
              child: new Text(
                widget._header,
                style: _titleStyle,
                softWrap: true,
                textAlign: TextAlign.left,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 15.0, right: 10.0),
              child: new Text(
                widget._body,
                style: _bodyStyle,
                textAlign: TextAlign.left,
              ),
            ),
            
          ],
        ),
         color: Colors.white,
      ),
    );
  }
}
