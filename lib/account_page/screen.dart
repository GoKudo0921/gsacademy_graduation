// screen.dart
import 'package:flutter/material.dart';
import '../function_page/invitation_page.dart';
import '../function_page/performance_page.dart';
import '../function_page/seat_page.dart';
import '../function_page/task_page.dart';
import 'top_page.dart';

class Screen extends StatefulWidget {
  final int selectedIndex;

  const Screen({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;

  List<Widget> pageList = [
    const TopPage(),
    InvitationPage(),
    const SeatPage(),
    const TaskPage(),
    const PerformancePage(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return true;
    },
    child: Scaffold(
    body: pageList[selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    items: const [
    BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'ホーム',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.people),
    label: '招待客',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.airline_seat_recline_normal_rounded),
    label: '席次表',
    ),
      BottomNavigationBarItem(
        icon: Icon(Icons.task_sharp),
        label: 'タスク表',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.movie_outlined),
        label: '演出',
      ),
    ],
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    ),
    ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: Screen(),
  ));
}