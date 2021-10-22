import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Tasks", home: taskList());
  }
}

var tasks = [];

bool startup = true;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;

  return File('$path/tasks.txt');
}

Future<File> writeTasks() async {
  final file = await _localFile;

  return file.writeAsString(tasks.join(';'));
}

Future<String?> readTasks() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return null;
  }
}

class taskList extends StatefulWidget {
  const taskList({Key? key}) : super(key: key);
  @override
  _taskListState createState() => _taskListState();
}

final controller = new TextEditingController();

bool isTyping = false;

class _taskListState extends State<taskList> {
  @override
  Widget build(BuildContext context) {
    if (startup) {
      readTasks().then((value) => {
            setState(() {
              tasks = value?.split(';') ?? [];
            })
          });
      startup = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        centerTitle: true,
        backgroundColor: Colors.orange[400],
      ),
      floatingActionButton: Visibility(
        visible: isTyping,
        child: FloatingActionButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            setState(() {
              tasks.add(controller.text);
              isTyping = false;
              controller.clear();
            });
            writeTasks();
          },
          backgroundColor: Colors.orange[600],
          child: Icon(
            Icons.add,
            size: 40,
          ),
          splashColor: Colors.blue,
          elevation: 12,
        ),
      ),
      backgroundColor: Colors.orange[200],
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller,
                        cursorColor: Colors.black,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(hintText: "New task"),
                        onChanged: (String text) {
                          if (text.length != 1) {
                            setState(() {
                              isTyping = true;
                            });
                          } else {
                            setState(() {
                              isTyping = true;
                            });
                          }
                        },
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            flex: 13,
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      )),
                  leading: IconButton(
                    icon: Icon(Icons.circle_outlined),
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
