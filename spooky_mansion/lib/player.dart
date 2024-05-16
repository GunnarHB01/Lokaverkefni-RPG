import 'room.dart';
import 'item.dart';

class Player {
  String name;
  Room currentRoom;
  List<Item> inventory = [];

  Player(this.name, this.currentRoom);

  bool move(String direction) {
    Room? nextRoom = currentRoom.getRoom(direction);

    if (nextRoom != null) {
      if (nextRoom.isLocked) {
        if (inventory.contains(nextRoom.key)) {
          nextRoom.isLocked = false;
          print('You use the key to unlock the door.');
        } else {
          print('The door is locked. You need a key.');
          return false;
        }
      }
      currentRoom = nextRoom;
      print('You moved to: ${currentRoom.name}');
      return true;
    } else {
      print('You cannot go that way.');
      return false;
    }
  }

  void pickUpItem(String itemName) {
    Item? item;
    for (var i in currentRoom.items) {
      if (i.name.toLowerCase() == itemName.toLowerCase()) {
        item = i;
        break;
      }
    }

    if (item != null) {
      inventory.add(item);
      currentRoom.items.remove(item);
      print('You picked up: ${item.name}');
    } else {
      print('No such item here.');
    }
  }

  void showInventory() {
    print('Your inventory: ${inventory.map((item) => item.name).join(', ')}');
  }

  void showAvailableDirections() {
    currentRoom.connections.forEach((direction, room) {
      print('$direction: ${room.name}');
    });
  }
}
