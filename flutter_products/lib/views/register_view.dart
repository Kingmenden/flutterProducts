import 'package:flutter/material.dart';
import 'package:flutter_products/constants.dart';
//import 'package:get_it/get_it.dart';
//import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
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
          //  'https://supabase.io/new/images/logo-dark.png',
          //  width: 300,
          //)),
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
                      //Email Input
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
                      //Name Input
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: _nameController,
                          cursorColor: Colors.black,
                          style: const TextStyle(),
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Password Input
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
                        height: 10,
                      ),
                      //Confirm Password Input
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          obscureText: true,
                          style: const TextStyle(),
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty ||
                                value != _passwordController.text) {
                              return 'Passwords don\'t match';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: size.width,
                        height: 45,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _register();
                            }
                          },
                          color: Colors.black,
                          child: const Text(
                            'Register',
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
                          const Text('Already have an account?'),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Login',
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

  Future _register() async {
    try {
      String name = '';
      AuthResponse result;
      print(_nameController.text);
      if (_nameController.text != '') {
        name = _nameController.text;
        Map<String, dynamic> mapData = {"full_name": name};
        result = await supabase.auth.signUp(
            email: _emailController.text,
            password: _passwordController.text,
            data: mapData);
      } else {
        result = await supabase.auth.signUp(
            email: _emailController.text, password: _passwordController.text);
      }
      if (result.session != null) {
        Navigator.pushReplacementNamed(context, '/login');
        _showDialog(context,
            title: 'Success', message: 'Registering Successful, Please login');
      } else if (result.session == null) {
        _showDialog(context, title: 'Error', message: 'Unable to signup');
      }

      setState(() {
        // just for simplicity reasons (clean the textfields)
      });
    } on Exception catch (_, e) {
      print(_);
      if (e.toString().contains('Email rate limit exceeded')) {
        print(e);
        _showDialog(context,
            title: 'Error',
            message: 'Unable to signup due to email constraints');
      } else if (e.toString().contains('Registered')) {
        print(e);
        _showDialog(context,
            title: 'Error', message: 'User already Registered');
      } else {
        print(e);
        _showDialog(context,
            title: 'Error', message: 'Unable to signup due to error');
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
}
