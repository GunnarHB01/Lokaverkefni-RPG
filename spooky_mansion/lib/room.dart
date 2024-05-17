import 'item.dart';

// The Room class represents a room in the game
class Room {
  String name; // The name of the room
  String description; // A description of the room
  String initialDescription; // The initial description of the room
  Map<String, Room> connections = {}; // A map of connected rooms (direction to room)
  List<Item> items = []; // A list of items in the room
  bool isLocked = false; // Indicates if the room is locked
  Item? key; // The key item needed to unlock the room (if any)
  bool discovered = false; // Indicates if the room has been discovered by the player
  bool hasTrap = false; // Indicates if the room has a trap

  // Constructor to create a room with a name, description, and optional properties
  Room(this.name, this.description, {this.isLocked = false, this.key, this.hasTrap = false})
      : initialDescription = description;

  // Connect this room to another room in a specified direction
  void connectRoom(String direction, Room room) {
    connections[direction.toLowerCase()] = room;
  }

  // Get the room connected in a specified direction
  Room? getRoom(String direction) {
    return connections[direction.toLowerCase()];
  }

  // Update the description of the room
  void updateDescription(String newDescription) {
    description = newDescription;
  }

  // Override the toString method to return a string representation of the room
  @override
  String toString() {
    return 'Room: $name\n$description\nItems: ${items.map((item) => item.name).join(', ')}';
  }
}
