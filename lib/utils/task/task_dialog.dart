import 'package:SmartWedding/utils/firestore/tasks.dart';
import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  const TaskDialog({super.key, required this.taskTitleController});

  final TextEditingController taskTitleController;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Text(
            'タスクの追加',
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.white,
            ),
          )
        ],
      ),
      children: [
        TextFormField(
          controller: taskTitleController,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '入場曲を決める',
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              if (taskTitleController.text.isNotEmpty) {
                await FetchTasks()
                    .createNewTask(taskTitleController.text.trim());
              }
              Navigator.pop(context);
              taskTitleController.clear();
            },
            child: const Text('追加'),
          ),
        )
      ],
    );
  }
}
