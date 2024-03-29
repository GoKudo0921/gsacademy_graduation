import 'package:SmartWedding/model/attendee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SmartWedding/utils/authentication.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Attendee>> getAttendees(String collectionName) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(Authentication.currentFirebaseUser?.uid)
        .collection(collectionName)
        .get();
    return snapshot.docs
        .map((doc) => Attendee(
              id: doc.id,
              name: doc.data()['name'] as String?,
              relation: doc.data()['relation'] as String?,
              seatNumber: doc.data()['seatNumber'] as String?,
            ))
        .toList();
  }

  Future<List<Attendee>> getAttendeesBySeatNumber(
      String collectionName, String seatNumber) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(Authentication.currentFirebaseUser?.uid)
        .collection(collectionName)
        .where('seatNumber', isEqualTo: seatNumber)
        .get();
    return snapshot.docs
        .map((doc) => Attendee.fromJson({
              'id': doc.id,
              'name': doc.data()['name'] as String?,
              'relation': doc.data()['relation'] as String?,
              'seatNumber': doc.data()['seatNumber'] as String?,
            }))
        .toList();
  }

  Future<List<List<Attendee>>> getAttendeesByTable(
      List<String> seatSets) async {
    final groomAttendees = await getAttendees('groomAttendees');
    final brideAttendees = await getAttendees('brideAttendees');
    final attendeesByTable =
        List.generate(seatSets.length, (_) => <Attendee>[]);

    for (int i = 0; i < seatSets.length; i++) {
      final seatNumber = seatSets[i];
      final groomAttendeesForSeat = groomAttendees
          .where((attendee) => attendee.seatNumber == seatNumber)
          .toList();
      final brideAttendeesForSeat = brideAttendees
          .where((attendee) => attendee.seatNumber == seatNumber)
          .toList();

      attendeesByTable[i] = [
        ...groomAttendeesForSeat,
        ...brideAttendeesForSeat
      ];
    }

    return attendeesByTable;
  }

  Future<List<String>> getSeatSets() async {
    final groomAttendees = await getAttendees('groomAttendees');
    final brideAttendees = await getAttendees('brideAttendees');
    final allAttendees = [...groomAttendees, ...brideAttendees];
    final seatSets = allAttendees
        .map((attendee) => attendee.seatNumber)
        .where((seatNumber) => seatNumber != null)
        .toSet()
        .toList()
      ..sort((a, b) => a!.compareTo(b!));
    return seatSets.whereType<String>().toList();
  }

  Future<void> deleteAttendee(Attendee attendee, String collectionName) async {
    final collection = _firestore
        .collection('users')
        .doc(Authentication.currentFirebaseUser?.uid)
        .collection(collectionName);
    await collection.doc(attendee.id).delete();
  }

  Future<void> saveAttendees(
      List<Attendee> attendees, String collectionName) async {
    final userDocRef = _firestore
        .collection('users')
        .doc(Authentication.currentFirebaseUser?.uid);
    final collection = userDocRef.collection(collectionName);

    for (final attendee in attendees) {
      final data = attendee.toJson();
      if (attendee.id == null) {
        await collection.add(data);
      } else {
        await collection.doc(attendee.id).set(data);
      }
    }
  }
}
