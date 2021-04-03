import 'dart:core';

//Model for a location.
class Location {
  //The id of a location
  final String id;

  //The name of a location
  final String name;

  //The address of a location
  final String address;

  //The information about a location
  final String info;

  //The tag of a location
  final String tag;

  Location({this.id, this.name, this.address, this.info, this.tag});

  //Creates a location from JSON representation.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        info: json['info'],
        tag: json['tag']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'address': address, 'info': info, 'tag': tag};
}

//Converts a list of locations [locations] to a Map containing location ids (key) to locations (value).
Map<String, Location> locationsById(List<Location> locations) {
  Map<String, Location> res = {};
  locations.forEach((element) {
    res[element.id] = element;
  });
  return res;
}
