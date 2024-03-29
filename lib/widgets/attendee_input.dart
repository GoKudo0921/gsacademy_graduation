import 'package:SmartWedding/model/attendee.dart';
import 'package:flutter/material.dart';

class AttendeeInput extends StatefulWidget {
  final Attendee attendee;
  final bool isGroomSide;
  final void Function(String? seatNumber) onSeatSelected;

  const AttendeeInput({
    Key? key,
    required this.attendee,
    required this.isGroomSide,
    required this.onSeatSelected,
  }) : super(key: key);

  @override
  State<AttendeeInput> createState() => _AttendeeInputState();
}

class _AttendeeInputState extends State<AttendeeInput> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.attendee.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final seatSets =
        List.generate(26, (index) => String.fromCharCode(65 + index));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: 150,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '参列者',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onChanged: (value) {
                  widget.attendee.name = value;
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              width: 150,
              child: DropdownButton<String?>(
                value: widget.attendee.relation,
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      '続柄',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  DropdownMenuItem(value: '父', child: Text('父')),
                  DropdownMenuItem(value: '母', child: Text('母')),
                  DropdownMenuItem(value: '兄', child: Text('兄')),
                  DropdownMenuItem(value: '姉', child: Text('姉')),
                  DropdownMenuItem(value: '兄の妻', child: Text('兄の妻')),
                  DropdownMenuItem(value: '姉の夫', child: Text('姉の夫')),
                  DropdownMenuItem(value: '弟', child: Text('弟')),
                  DropdownMenuItem(value: '妹', child: Text('妹')),
                  DropdownMenuItem(value: '弟の妻', child: Text('弟の妻')),
                  DropdownMenuItem(value: '妹の夫', child: Text('妹の夫')),
                  DropdownMenuItem(value: '甥', child: Text('甥')),
                  DropdownMenuItem(value: '姪', child: Text('姪')),
                  DropdownMenuItem(value: '祖父', child: Text('祖父')),
                  DropdownMenuItem(value: '祖母', child: Text('祖母')),
                  DropdownMenuItem(value: '伯父', child: Text('伯父')),
                  DropdownMenuItem(value: '伯母', child: Text('伯母')),
                  DropdownMenuItem(value: '叔父', child: Text('叔父')),
                  DropdownMenuItem(value: '叔母', child: Text('叔母')),
                  DropdownMenuItem(value: '上司', child: Text('上司')),
                  DropdownMenuItem(value: '友人', child: Text('友人')),
                  DropdownMenuItem(value: '同僚', child: Text('同僚')),
                  DropdownMenuItem(value: '主賓', child: Text('主賓')),
                ],
                onChanged: (String? value) {
                  setState(() {
                    widget.attendee.relation = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              width: 100,
              child: DropdownButton<String?>(
                value: widget.attendee.seatNumber,
                items: seatSets.map((seatNumber) {
                  return DropdownMenuItem<String?>(
                    value: seatNumber,
                    child: Text(seatNumber),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    widget.attendee.seatNumber = value;
                    widget.onSeatSelected(value);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
