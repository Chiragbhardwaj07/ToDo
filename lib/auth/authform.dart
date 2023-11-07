import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _email = '';
  String _password = '';
  String _username = '';
  bool isLoginPage = false;

  void startAuthentication() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _username);
    }
    Navigator.pop(context);
  }

  void submitForm(String email, String password, String username) async {
    try {
      if (isLoginPage) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        final authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final uid = authResult.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(child: Text('Invalid Credentials')),
        backgroundColor: Color.fromARGB(255, 250, 94, 82),
      ));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                child: Text(
                  isLoginPage
                      ? 'Welcome back\nYou\'ve been missed!'
                      : 'Register',
                  style: GoogleFonts.abel(
                    color: Colors.grey[500],
                    fontSize: 36,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!isLoginPage)
                      TextFormField(
                        key: ValueKey('username'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Incorrect Username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'Enter Username',
                        ),
                      ),
                    SizedBox(height: 10),
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Enter Email',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      key: ValueKey('password'),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Enter Password',
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: startAuthentication,
                        child: Text(isLoginPage ? 'Login' : 'SignUp'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: Text(
                          isLoginPage ? 'Not a member?' : 'Already a Member?'),
                    ),
                    const SizedBox(height: 30),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 69,
                          width: 69,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage('assets/google.svg'))),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          height: 69,
                          width: 69,
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage('assets/Apple.svg'))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
