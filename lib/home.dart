import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern_test/add_photo.dart';
import 'package:intern_test/photo_page.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class HomePage extends StatefulWidget {
    Auth auth;
    HomePage({this.auth});

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  Timer timer;
  FirebaseUser user;
  bool check = false;

  @override
  void initState(){
    widget.auth.verifyEmail();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test APP'),
        actions: [
          check ? null : Text('Wait for email verification')
        ],
      ),
      floatingActionButton: check ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          AddPhotoPage();
        },
      ) : null,
      body: Column(
        children: [
          FlatButton(
            child: Text('signout'),
            onPressed: () async {
              widget.auth.signOut();
            },
          ),
          PhotosPage(),
        ],
      ),
    );
  }


  Future<void> checkEmailVerified() async{
    user = await widget.auth.currentUser();
    await user.reload();
    print('running');
    if (user.isEmailVerified) {
      print('verified');
      timer.cancel();
      setState(() {
        check = true;
      });
    }
  }
}
