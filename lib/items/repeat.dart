class Repeat {
  String name, ref;
  int interval;
  List<String> cars = [];

  Repeat(this.name, this.interval, {this.ref, this.cars});

  Repeat.fromJSON(Map<String, dynamic> json, String documentID) {
    name = json['name'];
    interval = json['interval'];
    ref = documentID;
    cars = json['cars'] ?? [];
  }

  Repeat.empty() {
    name = '';
    interval = 0;
    cars = [];
  }

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "interval": interval,
      "cars": cars,
    };
  }
}