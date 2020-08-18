import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:toast/toast.dart';

import 'crediantial.dart';
import 'dropdown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter forget pass recover',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
        
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Expense(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool verifyButton = false;
  TextEditingController user = TextEditingController();
  String verifylink;
  Future checkUser() async {
    if (user.text.isNotEmpty) {
      var response = await http.post(
          'http://192.168.1.103/flutter-forget-pass-recover/check.php',
          body: {"username": user.text});
      var link = json.decode(response.body);
      
      if (link == 'INVALIDUSER') {
        showToast(
          "There have no user this type in our database",
          duration: 6,
          gravity: Toast.CENTER);
      }else{
        setState(() {
          verifylink = link;
          verifyButton = true;
          sendMail();
        });
        showToast(
          "Click The Verify Button To Change The Password",
          duration: 4,
          gravity: Toast.CENTER);
      }
      print(link);
    } else {
      showToast("Enter User Email",
          duration: 3, gravity: Toast.TOP);
    }
    
  }
  int newPass = 0;
  Future verify(String verifylink) async {
    var response = await http.post(verifylink);
    var link = json.decode(response.body);
    
    setState(() {
      newPass = link;
    });
    showToast("Your password has been change! you new password : $newPass",
        duration: 5, gravity: Toast.CENTER);
    print(link);
  }

  //mail
  sendMail() async {
    String username = EMAIL;
    String password = PASS;

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('signaturesoftit@gmail.com') //recipent email
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      //..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject =
          'Password recover link from shawondeveloper : ${DateTime.now()}' //subject of the email
      //..text =
      //'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h3>Thanks for with localhost. Please click this link to reset your password</h3>\n<p> <a href='$verifylink'>Click me to reset</a></p>"; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recover Your Password'),),
      body: Container(
        child: Column(

          children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: user,
              decoration: InputDecoration(hintText: 'Enter Your Email'),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              color: Colors.orange[400],
              child: Text('Recover Passowrd'),
              onPressed: (){
                checkUser();
                setState(() {
                  user.text = "";
                });
              },),
          ),

          verifyButton ? MaterialButton(
              color: Colors.red[400],
              child: Text('Verify',style: TextStyle(color: Colors.white),),
              onPressed: (){
                setState(() {
                  verifyButton = false;
                  verify(verifylink);

                });
              },): Container(),
              SizedBox(height: 40,),
          newPass == 0 ? Container() : Text('Your New Password: $newPass',style: TextStyle(fontSize: 20,color: Colors.green),),
        ],),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}