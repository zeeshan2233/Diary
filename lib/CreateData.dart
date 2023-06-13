import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class Create_Data extends StatefulWidget {
  const Create_Data({super.key});

  @override
  State<Create_Data> createState() => _Create_DataState();
}

class _Create_DataState extends State<Create_Data> {
  File? imagebuy;
  final titleControler = TextEditingController();
  final desControler = TextEditingController();
  final tiemControler = TextEditingController();
  final _formskey = GlobalKey<FormState>();
  final datetime = DateTime.now().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create New Notes"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formskey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //image code
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 15,
                    controller: titleControler,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "required";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Title"),
                  ),
                ),
                //datetime

                //

                //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 150,
                    controller: desControler,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "required";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintMaxLines: 4,
                        border: OutlineInputBorder(),
                        hintText: "Description"),
                  ),
                ),
                //
                ElevatedButton(
                    onPressed: () {
                      if (_formskey.currentState!.validate()) {
                        saveData();
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  //clear data
  clearData() {
    titleControler.clear();
    desControler.clear();
  }

  //save data
  Future<void> saveData() async {
    var title = titleControler.text.trim();
    var description = desControler.text.trim();

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("imagebuy")
        .child("v1")
        .putFile(imagebuy!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    FirebaseFirestore.instance.collection("PublicData").add({
      "Title": title,
      "Description": description,
      "profilepick": downloadUrl,
    }).then((value) => {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Save Data Sucessfully")))
        });
  }
}
