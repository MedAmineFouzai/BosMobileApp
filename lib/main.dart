import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BosApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'BlackOut Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _color = Colors.yellow;
  int _pressed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Container(
          width: 200.0,
          height: 200.0,
          child: new RawMaterialButton(
            splashColor: Colors.black,
            shape: new CircleBorder(),
            elevation: 0.0,
            child: Icon(
              Icons.offline_bolt,
              color: _color,
              size: 200,
            ),
            onLongPress: () async {
              var response = await http.get("https://boscts.herokuapp.com/");
              var jsonResponse = convert.jsonDecode(response.body);
              print(jsonResponse['DNS']);
              var cancel = "http://${jsonResponse['DNS']}/cancel";
              var shutdown = "http://${jsonResponse['DNS']}/shutdown";
              if (_pressed % 2 == 0) {
                var response = await http.get(shutdown);
                var jsonResponse = convert.jsonDecode(response.body);
                print(jsonResponse);
                setState(() {
                  _color = Colors.black;
                  _pressed++;
                });
              } else {
                var response = await http.get(cancel);
                var jsonResponse = convert.jsonDecode(response.body);
                print(jsonResponse);
                setState(() {
                  _color = Colors.yellow;
                  _pressed++;
                });
              }
            },
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
