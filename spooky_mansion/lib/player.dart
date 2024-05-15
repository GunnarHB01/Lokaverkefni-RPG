import 'room.dart';

class Player {
  String name;
  Room currentRoom;

  Player(this.name, this.currentRoom);

  void move(String direction) {
    Room? nextRoom = currentRoom.getRoom(direction);
    if (nextRoom != null) {
      currentRoom = nextRoom;
      print('You moved to: ${currentRoom.name}');
    } else {
      print('You cannot go that way.');
    }
  }
}
