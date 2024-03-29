import 'package:SmartWedding/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'image_path': newAccount.imagePath,
      });
      print('新規ユーザの登録完了');
      return true;
    } on FirebaseException catch (e) {
      print('新規ユーザの作成エラー$e');
      return false;
    }
  }
}