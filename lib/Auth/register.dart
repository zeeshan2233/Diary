// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary/Auth/Login.dart';

class User_Register extends StatefulWidget {
  const User_Register({Key? key}) : super(key: key);

  @override
  State<User_Register> createState() => _User_RegisterState();
}

class _User_RegisterState extends State<User_Register> {
  final _formkey = GlobalKey<FormState>();

  File? imagebuy;

  // used text controler

  final emailcontroler = TextEditingController();
  final namacontroler = TextEditingController();
  final passwordcontroler = TextEditingController();
  final confirmpassControler = TextEditingController();

  registration() async {
    var password = passwordcontroler.text.trim();
    var email = emailcontroler.text.trim();
    var confirmpass = confirmpassControler.text.trim();
    if (password == confirmpass) {
      try {
        User? user = await FirebaseAuth.instance.currentUser;

        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then(
          (value) {
            FirebaseFirestore.instance
                .collection("newUser")
                .doc(value.user!.uid)
                .set({
              "UserName": namacontroler.text.trim(),
              "Email": emailcontroler.text.trim(),
              // "Image": imagebuy,
            });
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registration Sucessfuly Login",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => User_Login(),
          ),
        );

        //weak passowrd
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: avoid_print
          print("passowrd provided is too weak");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "passowrd provided is too weak",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }

        //Email allready in used

        else if (e.code == 'email-already-in-use') {
          print("Account already exists");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.yellow,
              content: Text(
                "Account already exists",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }
      }
    } else {
      print("password and confirm password doesn't match");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Password and Confirm password doesn't match",
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer_SignUp")),
      body: Container(
        decoration: const BoxDecoration(),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),

              CupertinoButton(
                child: CircleAvatar(
                    backgroundImage:
                        (imagebuy != null) ? FileImage(imagebuy!) : null),
                onPressed: () async {
                  XFile? selectedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (selectedFile != null) {
                    File convertedfile = File(selectedFile.path);
                    setState(() {
                      imagebuy = convertedfile;
                    });
                  }
                },
              ),

              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    prefixIconColor: Colors.blue,
                    labelText: "UserNames",
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  controller: namacontroler,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter the UserName";
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    prefixIconColor: Colors.blue,
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                  ),
                  controller: emailcontroler,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter the Email";
                    } else if (!value.contains("@gmail")) {
                      return "please enter the correct email";
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                child: TextFormField(
                  obscureText: true,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    prefixIconColor: Colors.blue,
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: passwordcontroler,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please Enter the password";
                    }
                    return null;
                  },
                ),
              ),

              //confirm password

              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
                child: TextFormField(
                  obscureText: true,
                  autofocus: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password_rounded),
                    prefixIconColor: Colors.blue,
                    labelText: " Confirm Password",
                    labelStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: confirmpassControler,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please Enter the Confirm password";
                    }
                    return null;
                  },
                ),
              ),

              // button

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        registration();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => User_Login()));
                      }
                    },
                    child: const Text("SignUp",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text("Already have a Account?")),
                  ),
                  TextButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const User_Login())),
                          },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
