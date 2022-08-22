import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    // var data = await http.get("\https://json-generator.com/api/json/get/cfwZmvEBbC?indent=2");

    // Future<Future<http.Response>> _getUsers () async {
    //   return http.get(Uri.parse('https://json-generator.com/api/json/get/cfwZmvEBbC?indent=2'));
    //
    var data = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(
        u["postId"],
        u["id"],
        u["name"],
        u["email"],
        u["body"],
      );

      users.add(user);
    }

    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      snapshot.data[index].name,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    textColor: Colors.black,
                    subtitle: Text(snapshot.data[index].body),
                    tileColor: Colors.grey,

                    //Page navigation
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final User user;

  DetailsPage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email),
      ),
    );
  }
}

class User {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  User(
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  );
}
