import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class update_value extends StatefulWidget {
  String id;
  String title;
  String description;
  update_value(
      {super.key,
      required this.description,
      required this.title,
      required this.id});

  @override
  State<update_value> createState() => _update_valueState();
}

class _update_valueState extends State<update_value> {
  final titleControler = TextEditingController();
  final desControler = TextEditingController();

  final _formskey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update"),
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
                        border: OutlineInputBorder(), hintText: widget.title),
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
                        hintText: widget.description),
                  ),
                ),
                //
                ElevatedButton(
                    onPressed: () {
                      if (_formskey.currentState!.validate()) {
                        updatedata(
                            widget.id, titleControler.text, desControler.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("update"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  updatedata(String id, String des, String title) async {
    await FirebaseFirestore.instance.collection("PublicData").doc(id).update({
      "Title": title,
      "Description": des,
    });
  }

  //clear data
  clearData() {
    titleControler.clear();
    desControler.clear();
  }

  //save data
}
