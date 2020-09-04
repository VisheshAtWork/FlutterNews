import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'KnowMore.dart';
import 'news.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsPage(),
      title: 'Inshorts Clone',
      theme: new ThemeData(
        accentColor: Colors.lightBlue,
        primaryColor: Colors.grey,
      ),
    ));

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var headerList = ['English', 'Hindi'];
  var index = 0;
  String url;
  List<News> _list = new List<News>();
  Future<List<News>> fetchNews() async {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    final response = await http.get(
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=56b2116e5a8843c9961158494b946498');
    Map map = json.decode(response.body);
    final responseJson = json.decode(response.body);
    for (int i = 0; i < map['articles'].length; i++) {
      if (map['articles'][i]['author'] != null) {
        _list.add(new News.fromJson(map['articles'][i]));
      }
    }
    return _list;
  }

  _refresh() {
    setState(() {
      fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Trending'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refresh,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(2, (index) {
                        return Center(
                          child: Text(
                            headerList[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            CustomListTile(),
          ],
        ),
      ),
      body: FutureBuilder(
          future: fetchNews(),
          builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
            if (snapshot.hasData) {
              url = snapshot.data[index].url.toString();
              return Dismissible(
                key: Key(index.toString()),
                direction: DismissDirection.vertical,
                onDismissed: (direction) {
                  setState(() {
                    if (direction == DismissDirection.up) index++;
                    if (direction == DismissDirection.down && index != 0)
                      index--;
                  });
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            snapshot.data[index].urlToImage,
                            fit: BoxFit.contain,
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              '${snapshot.data[index].title}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              '${snapshot.data[index].description}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          return Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KnowMore(url)));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: Center(
                                child: Text(
                              "Tap to know more",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                            color: Colors.blueGrey,
                            elevation: 5,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LinearProgressIndicator());
            }
          }),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Image.network(
            "https://ichef.bbci.co.uk/news/1024/cpsprodpb/121A2/production/_111764147_breaking_news_bigger-nc.png",
            scale: 0.5,
          ),
          Text('Flutter News')
        ],
      ),
    );
  }
}
