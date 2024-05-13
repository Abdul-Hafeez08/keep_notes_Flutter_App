import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> list = [];
  var value = '';
  var deleteIndex = -1;
  TextEditingController task = TextEditingController();
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list = prefs.getStringList('items')!;
    });
  }

  void addTask() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list.add(value);
    });
    await prefs.setStringList('items', list);
  }

  void deleteTask() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list.removeAt(deleteIndex);
    });
    await prefs.setStringList('items', list);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WORK TODO',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 370,
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextField(
                  controller: task,
                  onChanged: (text) {
                    value = text;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Text Here",
                    hintStyle: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              child: OutlinedButton.icon(
                onPressed: () {
                  task.clear();
                  addTask();
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.orange,
                ),
                label: const Text(
                  'ADD',
                  style: TextStyle(color: Colors.orange),
                ),
                style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Colors.orange))),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: 370,
                height: 450,
                child: ListView(
                  children: [
                    for (int i = 0; i < list.length; i++) ...[
                      Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 50,
                          width: 370,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.orange[400]),
                          child: ListTile(
                            trailing: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  deleteIndex = i;
                                  deleteTask();
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            title: Text(
                              list[i],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                          )),
                    ]
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
