import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Expense extends StatefulWidget {
  Expense() : super();

  final String title = "DropDown Demo";

  @override
  ExpenseState createState() => ExpenseState();
}


class ExpenseState extends State<Expense> {

  List data = List();
  String expenseelement;
  bool isLoading = true;

  Future getAllName() async {
    var response = await http.get("http://192.168.1.103/blog_flutter/postAll.php",
        headers: {"Accept": "application/json"});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);
    setState(() {
      data = jsonData;
    });
    print(jsonData);

    //return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff6101),
        title: Text('Add Expense '),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("Site",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      value: expenseelement,
                      hint: Text("Select site"),
                      items: data.map((list){
                        return DropdownMenuItem(
                          child: Text(list['title']),
                          value: list['id'].toString(),
                        );
                      },).toList(),
                      onChanged: (value){
                        setState(() {
                          expenseelement = value;
                        });
                      },
                    ),
                  ),
            ]
        ),
      ),
    );
  }
}