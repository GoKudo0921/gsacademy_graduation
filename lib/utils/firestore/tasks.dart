import 'package:SmartWedding/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SmartWedding/utils/authentication.dart';

class FetchTasks {
  CollectionReference taskCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(Authentication.currentFirebaseUser?.uid)
      .collection('TaskList');

  Stream<List<TaskItem>> listTask() {
    return taskCollection
        .orderBy('Timestamp', descending: true)
        .snapshots()
        .map(taskFromFirebase);
  }

  Future createNewTask(String title) async {
    return await taskCollection.add({
      'title': title,
      'isCompleted': false,
      'Timestamp': FieldValue.serverTimestamp()
    });
  }

  Future updateTask(uid, bool newCompleteTask) async {
    await taskCollection.doc(uid).update({'isCompleted': newCompleteTask});
  }

  Future deleteTask(uid) async {
    await taskCollection.doc(uid).delete();
  }

  List<TaskItem> taskFromFirebase(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      Map<String, dynamic>? data = e.data() as Map<String, dynamic>?;

      return TaskItem(
        isCompleted: data?['isCompleted'] ?? true,
        title: data?['title'] ?? '',
        uid: e.id,
      );
    }).toList();
  }
}