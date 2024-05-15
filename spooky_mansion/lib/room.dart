import 'item.dart';

class Room {
  String name;
  String description;
  Map<String, Room> connections = {};
  List<Item> items = [];

  Room(this.name, this.description);

  void connectRoom(String direction, Room room) {
    connections[direction.toLowerCase()] = room;
  }

  Room? getRoom(String direction) {
    return connections[direction.toLowerCase()];
  }

  @override
  String toString() {
    return 'Room: $name\n$description\nItems: ${items.map((item) => item.name).join(', ')}';
  }
}
