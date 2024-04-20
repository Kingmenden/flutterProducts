import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_products/constants.dart';
//import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  void checkLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    //print('sharedPreferences: ');
    //print(sharedPreferences);
    //print(sharedPreferences.getKeys());
    if (sharedPreferences.containsKey(PERSIST_SESSION_KEY) &&
        sharedPreferences.get(PERSIST_SESSION_KEY) != null) {
      //final session = sharedPreferences.getString(PERSIST_SESSION_KEY);
      //var jsonSess = sharedPreferences.getString('session');
      var encodedSessJson = sharedPreferences.getString(PERSIST_SESSION_KEY);
      //print(encodedSessJson);
      //var decodedSess = json.decode(jsonSess!);
      //var encodedSess = jsonEncode(encodedSessJson).toString();
      //print(encodedSess);
      //print(session);
      //print(jsonSess);
      //var user = sharedPreferences.get('user');
      //print(user);
      //if (null == null) {
      if (encodedSessJson == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        //print(encodedSessJson);
        try {
          final response =
              await supabase.auth.recoverSession(encodedSessJson); //session);

          sharedPreferences.setString(
              'user', response.session!.user.toString());
          var encodedJson = jsonEncode(response.session!);
          await sharedPreferences.setString(PERSIST_SESSION_KEY, encodedJson);

          Navigator.pushReplacementNamed(context, '/home');
        } on Exception catch (_, e) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
