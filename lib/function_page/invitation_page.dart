import 'package:SmartWedding/model/attendee.dart';
import 'package:SmartWedding/services/firestore_service.dart';
import 'package:SmartWedding/widgets/attendee_input.dart';
import 'package:flutter/material.dart';

class InvitationPage extends StatefulWidget {
  const InvitationPage({super.key});

  @override
  State<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Attendee> groomAttendees = [];
  List<Attendee> brideAttendees = [];
  List<String> seatSets = [];

  @override
  void initState() {
    super.initState();
    _loadAttendees();
  }

  Future<void> _loadAttendees() async {
    groomAttendees = await _firestoreService.getAttendees('groomAttendees');
    brideAttendees = await _firestoreService.getAttendees('brideAttendees');
    seatSets = await _firestoreService.getSeatSets();
    print('Groom Attendees: $groomAttendees');
    print('Bride Attendees: $brideAttendees');
    print('Seat Sets: $seatSets');
    setState(() {});
  }

  void _addAttendee(bool isGroomSide) {
    setState(() {
      if (isGroomSide) {
        groomAttendees.add(Attendee());
      } else {
        brideAttendees.add(Attendee());
      }
    });
  }

  Future<void> _deleteAttendee(
      int index, List<Attendee> attendeesList, bool isGroomSide) async {
    final attendee = attendeesList[index];
    final collectionName = isGroomSide ? 'groomAttendees' : 'brideAttendees';
    await _firestoreService.deleteAttendee(attendee, collectionName);
    setState(() {
      attendeesList.removeAt(index);
    });
  }

  void _saveAttendees() {
    _firestoreService.saveAttendees(groomAttendees, 'groomAttendees');
    _firestoreService.saveAttendees(brideAttendees, 'brideAttendees');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('招待客'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTotalCountContainer(groomAttendees.length, '新郎側合計'),
              const SizedBox(width: 30),
              _buildTotalCountContainer(brideAttendees.length, '新婦側'),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAttendeeList(groomAttendees, true),
                  _buildAttendeeList(brideAttendees, false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCountContainer(int count, String label) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            '$count人',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeeList(List<Attendee> attendeesList, bool isGroomSide) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: Center(
                child: Text(
                  isGroomSide ? '新郎側' : '新婦側',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _saveAttendees,
              child: const Text('保存'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: attendeesList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AttendeeInput(
                          attendee: attendeesList[index],
                          isGroomSide: isGroomSide,
                          onSeatSelected: (seatNumber) {
                            setState(() {
                              attendeesList[index].seatNumber = seatNumber;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_forever_outlined,
                            color: Colors.red),
                        onPressed: () {
                          _deleteAttendee(index, attendeesList, isGroomSide);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(
                Icons.add_circle_outlined,
                color: Colors.green,
              ),
              onPressed: () {
                _addAttendee(isGroomSide);
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
