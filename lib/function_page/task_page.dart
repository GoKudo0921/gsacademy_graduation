import 'package:SmartWedding/model/task.dart';
import 'package:SmartWedding/utils/firestore/tasks.dart';
import 'package:SmartWedding/utils/task/loader.dart';
import 'package:SmartWedding/utils/task/task_dialog.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController taskTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('タスク表'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<TaskItem>>(
          stream: FetchTasks().listTask(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loader();
            }
            List<TaskItem>? task = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'タスク',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: task!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(task[index].uid),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.red,
                            child: const Icon(Icons.delete),
                          ),
                          onDismissed: (direction) async {
                            await FetchTasks().deleteTask(task[index].uid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ListTile(
                                onTap: () {
                                  bool newCompleteTask =
                                  !task[index].isCompleted;
                                  FetchTasks().updateTask(
                                    task[index].uid,
                                    newCompleteTask,
                                  );
                                },
                                leading: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.purple,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: task[index].isCompleted
                                      ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                      : Container(),
                                ),
                                title: Text(
                                  task[index].title,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TaskDialog(
              taskTitleController: taskTitleController,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}