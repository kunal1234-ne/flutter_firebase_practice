import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.cyan,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String studentName, studentId, studyProgramID;
  late double studentGpa;

  getStudentName(name) {
    this.studentName = name;
  }

  getStudentId(id) {
    this.studentId = id;
  }

  getStudyProgramID(programid) {
    this.studyProgramID = programid;
  }

  getStudentGpa(gpa) {
    this.studentGpa = double.parse(gpa);
  }

  createData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students = {
      "sname": studentName,
      "sid": studentId,
      "spid": studyProgramID,
      "sgpa": studentGpa
    };

    documentReference.set(students).whenComplete(() => null);
  }

  readData() {
    FirebaseFirestore.instance
        .collection('MyStudents')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["sname"]);
        print(doc["sid"]);
        print(doc["spid"]);
        print(doc["sgpa"]);
      });
    });
  }

  updateData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students = {
      "sname": studentName,
      "sid": studentId,
      "spid": studyProgramID,
      "sgpa": studentGpa
    };

    documentReference.set(students).whenComplete(() => null);
  }

  deleteData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    documentReference.delete().whenComplete(() {
      print("$studentName deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Text('CRUD'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70, width: 2.0),
                    ),
                  ),
                  onChanged: (String name) {
                    getStudentName(name);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Student ID",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70, width: 2.0),
                    ),
                  ),
                  onChanged: (String id) {
                    getStudentId(id);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Study Program",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70, width: 2.0),
                    ),
                  ),
                  onChanged: (String programid) {
                    getStudyProgramID(programid);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "GPA",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70, width: 2.0),
                    ),
                  ),
                  onChanged: (String gpa) {
                    getStudentGpa(gpa);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        createData();
                      },
                      child: Text('Create')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        readData();
                      },
                      child: Text('Read')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                      ),
                      onPressed: () {
                        updateData();
                      },
                      child: Text('Update')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        deleteData();
                      },
                      child: Text('Delete'))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 90.0,
                  top: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Name'),
                    Text('Student ID'),
                    Text('Study Program'),
                    Text('GPA'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("MyStudents")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(documentSnapshot["sname"]),
                                ),
                                Expanded(
                                  child: Text(documentSnapshot["sid"]),
                                ),
                                Expanded(
                                  child: Text(documentSnapshot["spid"]),
                                ),
                                Expanded(
                                  child:
                                      Text(documentSnapshot["sgpa"].toString()),
                                )
                              ],
                            );
                          });
                    } else {
                      return Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
