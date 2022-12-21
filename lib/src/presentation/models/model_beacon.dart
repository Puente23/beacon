import 'dart:convert';

Beacon beaconFromJson(String str) => Beacon.fromJson(json.decode(str));

String beaconToJson(Beacon data) => json.encode(data.toJson());

class Beacon {
  Beacon({
    this.name,
    required this.uuid,
    required this.macAddress,
    required this.major,
    required this.minor,
    required this.distance,
    required this.proximity,
    required this.scanTime,
    required this.rssi,
    required this.txPower,
  });

  final String? name;
  final String uuid;
  final String macAddress;
  final String major;
  final String minor;
  final String distance;
  final String proximity;
  final String scanTime;
  final String rssi;
  final String txPower;

  factory Beacon.fromJson(Map<String, dynamic> json) => Beacon(
        name: json["name"],
        uuid: json["uuid"],
        macAddress: json["macAddress"],
        major: json["major"],
        minor: json["minor"],
        distance: json["distance"],
        proximity: json["proximity"],
        scanTime: json["scanTime"],
        rssi: json["rssi"],
        txPower: json["txPower"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uuid": uuid,
        "macAddress": macAddress,
        "major": major,
        "minor": minor,
        "distance": distance,
        "proximity": proximity,
        "scanTime": scanTime,
        "rssi": rssi,
        "txPower": txPower,
      };
}
