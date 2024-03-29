class Attendee {
  String? id;
  String? name;
  String? relation;
  String? seatNumber;

  Attendee({this.id, this.name, this.relation, this.seatNumber});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'seatNumber': seatNumber,
    };
  }

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id'],
      name: json['name'],
      relation: json['relation'],
      seatNumber: json['seatNumber'],
    );
  }
}
