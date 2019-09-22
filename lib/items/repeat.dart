class Repeat {
  String name, ref;
  int interval;

  Repeat(this.name, this.interval, {this.ref});

  Repeat.fromJSON(Map<String, dynamic> json, String documentID) {
    name = json['name'];
    interval = json['interval'];
    ref = documentID;
  }

  Repeat.empty();

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "interval": interval
    };
  }
}