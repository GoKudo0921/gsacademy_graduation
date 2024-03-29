import 'package:flutter/material.dart';
import 'package:SmartWedding/model/attendee.dart';
import 'package:SmartWedding/services/firestore_service.dart';

class SeatPage extends StatefulWidget {
  const SeatPage({super.key});

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> seatSets = [];
  List<List<Attendee>> attendeesByTable = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    seatSets = await _firestoreService.getSeatSets();
    attendeesByTable = await _firestoreService.getAttendeesByTable(seatSets);
    print('Seat Sets: $seatSets');
    print('Attendees by Table: $attendeesByTable');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('座席表'),
      ),
      body: attendeesByTable.isEmpty
          ? const Center(child: Text('招待客を登録してください'))
          : Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '新郎',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 80),
                    Text(
                      '新婦',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      width: 250,
                      height: 25,
                      color: Colors.pinkAccent,
                      child: const Center(
                        child: Text(
                          'メインテーブル',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),

                // 座席表の塊
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 1行に表示するセットの数
                      crossAxisSpacing: 10, // セット同士の横間隔
                      mainAxisSpacing: 10, // セット同士の縦間隔
                    ),
                    itemCount: seatSets.length,
                    itemBuilder: (context, index) {
                      final attendees = attendeesByTable[index];
                      return Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.pinkAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                seatSets[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                              children: attendees.map((attendee) {
                                return Text(
                                  attendee.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
