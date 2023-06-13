import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:my_diary/CreateData.dart';

import 'package:my_diary/update.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  var name;
  var email;
  var imag;
  getprofile() async {
    
    User? user = await FirebaseAuth.instance.currentUser;
    var profiledata = await FirebaseFirestore.instance
        .collection("RegisterUser")
        .doc(user!.uid)
        .get();
    setState(() {
      name = profiledata.data()!['UserName'];
      email = profiledata.data()!['Email'];
      imag = profiledata.data()!['Image'];
    });
  }

  @override
  void initState() {
    getprofile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(imag),
                ),
                accountName: Text(name),
                accountEmail: Text(email))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Dialy Notes"),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("PublicData").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (snapshots.hasData) {
              return ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, int Index) {
                    final result = snapshots.data!.docs[Index];
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 7,
                                    offset: Offset(0, 2),
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    result['Title'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    result['Description'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 40,
                          onPressed: () {
                            delete(result.id);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        Positioned(
                          right: 20,
                          child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => update_value(
                                          id: result.id,
                                          title: result['Title'],
                                          description: result['Description'])));
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                      ],
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Create_Data()));
        },
        child: Icon(Icons.note),
      ),
    );
  }

  void delete(String id) async {
    await FirebaseFirestore.instance.collection("PublicData").doc(id).delete();
  }

  upadates(String id) {
    FirebaseFirestore.instance.collection("PublicData").doc(id).update({});
  }
}
