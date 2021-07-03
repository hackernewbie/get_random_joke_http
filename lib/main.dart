import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Random Dad Jokes!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var _jokeToShow = null;
  bool isProgressVisible = false;

  Future _showChuckNorrizJoke() async {
    print('Getting Chuck Norriz jokes...');
    var baseURL =
        'https://matchilling-chuck-norris-jokes-v1.p.rapidapi.com/jokes/random';

    var errorMsg = '';

    try {
      var reqRandomJoke = await http.get(Uri.parse(baseURL), headers: {
        'accept': 'application/json',
        'x-rapidapi-key': '7de0b03108msh40f3ca3303c2429p12ee5ajsn64ae9ec20b20',
        'x-rapidapi-host': 'matchilling-chuck-norris-jokes-v1.p.rapidapi.com',
      });

      var response = json.decode(reqRandomJoke.body);
      //var receivedJoke = response['value'];

      setState(() {
        _jokeToShow = response['value'];
        isProgressVisible = false;
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  Future _getRandomJoke() async {
    print('Getting random joke...');

    var jokeApiURI = 'http://dad-jokes.p.rapidapi.com/random/joke';
    var errorMsg = '';

    try {
      var randomJoke = await http.get(
        Uri.parse(jokeApiURI),
        headers: {
          'X-RapidAPI-Key':
              '7de0b03108msh40f3ca3303c2429p12ee5ajsn64ae9ec20b20',
          'X-RapidAPI-Host': 'dad-jokes.p.rapidapi.com',
        },
      );

      var response = json.decode(randomJoke.body)[0];

      print(response);

      setState(() {
        _jokeToShow = response['setup'].toString();
      });
    } catch (exception) {
      setState(() {
        errorMsg = exception.toString();
        print(errorMsg);
      });
    }
  }

  void _loadProgress() {
    if (isProgressVisible) {
      setState(() {
        isProgressVisible = false;
      });
    } else {
      setState(() {
        isProgressVisible = true;
        _showChuckNorrizJoke();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isProgressVisible,
              child: Container(
                //margin: EdgeInsets.only(top: 50, bottom: 30),
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: _jokeToShow == null
                  ? Text('Loading..')
                  : Text(
                      '$_jokeToShow',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 100.0,
        width: 100.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: _loadProgress,
            //child: Icon(Icons.ac_unit_outlined),
            child: Text(
              'Get Joke!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10.0),
            ),
          ),
        ),
      ),
    );
  }
}
