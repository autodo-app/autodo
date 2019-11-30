class Repeat {
  String name, ref;
  int interval;
  List<dynamic> cars = [];

  Repeat(this.name, this.interval, {this.ref, this.cars});

  Repeat.fromJSON(Map<String, dynamic> json, String documentID) {
    this.name = json['name'];
    this.interval = json['interval'];
    this.ref = documentID;
    this.cars = json['cars'] ?? [];
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
