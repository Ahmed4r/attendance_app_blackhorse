import 'dart:developer';

import 'package:attendance_app/std_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCmRLtLOwu_hX2QQV3DDM2NY5GMiOSVrOo",
      appId: "1:790190106487:android:d1386a5d2e96acd62a2372",
      messagingSenderId: "790190106487",
      projectId: "student-e9987",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<StdModel> students = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  final StdCollectionName = 'stdData';
  Future<void> getStdData() async {
    try {
      final table = await db.collection(StdCollectionName).get();
      students = table.docs
          .map((e) => StdModel.fromJson(e.id, e.data()))
          .toList();
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateStdAttendance(String docID, String atd) async {
    try {
      await db.collection(StdCollectionName).doc(docID).update({'atd': atd});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteStd(String docID) async {
    try {
      await db.collection(StdCollectionName).doc(docID).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    getStdData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getStdData(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Student',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              const Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            final student = students[index];
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Name : ${student.name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Roll No. : ${student.rollNumber}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Age : ${student.age}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Attendance : ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              updateStdAttendance(student.id!, 'present');
                              getStdData();
                            },
                            child: Container(
                              width: 50,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                color: student.attendance == 'present'
                                    ? Colors.green
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: student.attendance == 'present'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              updateStdAttendance(student.id!, 'absent');
                              getStdData();
                            },
                            child: Container(
                              width: 50,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                color: student.attendance == 'absent'
                                    ? Colors.red
                                    : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: student.attendance == 'absent'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 290,
                  right: 0,
                  bottom: 0,
                  top: 0,

                  child: IconButton(
                    onPressed: () {
                      deleteStd(student.id!);
                      getStdData();
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: 5);
          },
          itemCount: students.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentPage()),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          tooltip: 'add',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddStudentPage extends StatelessWidget {
  AddStudentPage({super.key});
  final TextEditingController? nameController = TextEditingController();
  final TextEditingController? ageController = TextEditingController();
  final TextEditingController? rollNoController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> saveStdData() async {
    try {
      final student = StdModel(
        null,
        nameController!.text,
        ageController!.text,
        int.parse(rollNoController!.text),
        null,
      );
      if (nameController!.text.isNotEmpty &&
          ageController!.text.isNotEmpty &&
          rollNoController!.text.isNotEmpty) {
        await db.collection('stdData').add(student.tojson());
        nameController!.clear();
        ageController!.clear();
        rollNoController!.clear();

        log('saved');
      } else {
        log('error ');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Add',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            const Text(
              'Student',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            cucstomTextField('Enter Student Name', nameController),
            SizedBox(height: 20),
            Text(
              'Student Age',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            cucstomTextField('Enter Student Age', ageController),
            SizedBox(height: 20),
            Text(
              'Student Roll No.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            cucstomTextField('Enter Student Roll No.', rollNoController),

            SizedBox(height: 50),
            Center(
              child: InkWell(
                onTap: saveStdData,
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cucstomTextField(String? hintText, TextEditingController? controller) {
    return TextField(
      controller: controller,
      style: TextStyle(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}
