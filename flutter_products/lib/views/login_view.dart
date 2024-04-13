import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_products/constants.dart';
//import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:supabase/supabase.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      backgroundColor: const Color(0XFF181818),
    );
  }

  Widget _buildBody(context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          //Container(
          //    child: Image.network(
          //        'https://cdn.freebiesupply.com/logos/large/2x/parental-advisory-explicit-content-logo-svg-vector.svg',
          //        width: 300,
          //        height: 600)),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Card(
              elevation: 1,
              child: Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.black,
                          style: const TextStyle(),
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid e-mail';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.black,
                          obscureText: true,
                          style: const TextStyle(),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Invalid password';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: size.width,
                        height: 45,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          color: Colors.black,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _login() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    try {
      final result = await supabase.auth.signInWithPassword(
          email: _emailController.text, password: _passwordController.text);
      if (result.session != null) {
        var encodedJson = jsonEncode(result.session!);
        //await sharedPreferences.setString(
        //    'session', result.session!.toJson().toString());
        await sharedPreferences.setString(PERSIST_SESSION_KEY, encodedJson);
        await sharedPreferences.setString(
            'user', result.session!.user.toJson().toString());
        Navigator.pushReplacementNamed(context, '/home');
      } else if (result.session == null) {
        _showDialog(context,
            title: 'Error', message: 'Unable to login, retry password');
      }
    } on Exception catch (_, e) {
      print(Exception);
      print(e);
      _showDialog(context,
          title: 'Error', message: 'Unable to login, retry password');
    }
  }
}

void _showDialog(context, {String? title, String? message}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // retorna um objeto do tipo Dialog
      return AlertDialog(
        title: Text(title ?? ''),
        content: Text(message ?? ''),
        actions: <Widget>[
          // define os botões na base do dialogo
          MaterialButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
