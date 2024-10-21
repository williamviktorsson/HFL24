import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  var now = DateTime.now();

  var booking1 = Booking(time: now, description: "funny thing");
  var booking2 = BamboozleBooking(time: now, description: "funny thing");

  var later = now.add(Duration(hours: 2));

  print(booking1 == booking2);

  print(booking1);
  print(booking2);

  booking1.time = later;
  booking2.time = later;

  print(booking1);
  print(booking2);

  print(booking1 == booking2);
}

class Booking {
  DateTime _time;
  String description;

  Booking({required time, required this.description}) : _time = time;

  @override
  String toString() {
    return "Event: ${description} schedueled at: ${_time.day}/${_time.month}/${_time.year} - ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}";
  }

  set time(DateTime time) {
    this._time = time;
  }

  @override
  bool operator ==(Object other) {
    if (other is Booking &&
        this._time == other._time &&
        this.description == other.description) {
      return true;
    }
    return false;
  }
}

class BamboozleBooking extends Booking {
  BamboozleBooking({required super.time, required super.description});

  @override
  set time(DateTime time) {
    super._time = DateTime.fromMicrosecondsSinceEpoch(0);
  }
}

class Repository {
  List<Booking> _bookings = [
    Booking(time: DateTime.now(), description: "Exciting thing"),
    Booking(
        time: DateTime.now().add(Duration(days: 2, hours: 10)),
        description: "other thing")
  ];

  List<Booking> get bookings => _bookings;
}
