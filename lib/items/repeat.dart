class Repeat {
  String name, ref;
  int interval;

  Repeat(this.name, this.interval, {this.ref});

  Repeat.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    interval = json['interval'];
  }

  Repeat.empty();

  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "interval": interval
    };
  }
}