import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import './main.dart';
import 'dart:async';
import 'dart:convert';

class Article {
  String header;
  String body;
  String pubDate;

  Article(this.header, this.body, this.pubDate);

}

class Feed {
  final xml.XmlDocument document;
  final List<Widget> items = new List<Widget>();

  Feed(this.document){
    
    var items = document.findAllElements('item');
    
    var header = "HEADER";
    var body = "BODY";
    var timestamp = "TS";
    
      for (int i = 0; i < items.length; i++){
        items.elementAt(i).findElements("title").forEach((f)=> header = f.text);
        items.elementAt(i).findElements("description").forEach((f)=> body = f.text);
        items.elementAt(i).findElements("pubDate").forEach((f)=> timestamp = f.text);
        /*
        header = htmlEscape.convert(header);
        body = htmlEscape.convert(body);
        timestamp = htmlEscape.convert(timestamp); */
        var unescape = new HtmlUnescape();
        body = unescape.convert(body);
       

        this.items.add(new NewsCard(header,body,timestamp));
      }
      
  }

  factory Feed.fromString(String data) {
    return new Feed(xml.parse(data));
  }
}

Future<Feed> fetchFeed() async {
  final response = await http.get('https://595.commons.hwdsb.on.ca/presentation/announcements/feed/');
  final responseXml = xml.parse(response.body);


  return new Feed(responseXml);
}

