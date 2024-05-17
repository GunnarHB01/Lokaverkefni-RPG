import 'room.dart';
import 'item.dart';

// The Player class represents the player in the game
class Player {
  String name; // The name of the player
  Room currentRoom; // The room the player is currently in
  List<Item> inventory = []; // The player's inventory (list of items)
  Set<String> discoveredRooms = {}; // A set of discovered room names (for navigation)

  // Constructor to create a player with a name and starting room
  Player(this.name, this.currentRoom);

  // Method to move the player to a new room or direction
  bool move(String directionOrRoom) {
    Room? nextRoom;

    // Check if the input is a room name or direction and get the corresponding room
    if (discoveredRooms.contains(directionOrRoom.toLowerCase())) {
      nextRoom = currentRoom.connections.values.firstWhere(
        (room) => room.name.toLowerCase() == directionOrRoom.toLowerCase(),
        orElse: () => Room('Invalid', 'Invalid room'),
      );
      if (nextRoom.name == 'Invalid') {
        nextRoom = null;
      }
    } else {
      nextRoom = currentRoom.getRoom(directionOrRoom);
    }

    // If the next room exists, handle movement
    if (nextRoom != null) {
      if (nextRoom.isLocked) {
        // Check if the room is locked and if the player has the key to unlock it
        if (inventory.contains(nextRoom.key)) {
          nextRoom.isLocked = false;
          print('You use the key to unlock the door.');
          if (nextRoom.name == 'Strange room') {
            nextRoom.updateDescription('The room has an eerie feeling and old furniture covered in dust.');
          }
        } else {
          print('The door is locked. You need a key.');
          return false;
        }
      }
      // Move the player to the next room and mark it as discovered
      currentRoom = nextRoom;
      currentRoom.discovered = true;
      discoveredRooms.add(currentRoom.name.toLowerCase());
      print('You moved to: ${currentRoom.name}');
      return currentRoom.hasTrap;
    } else {
      print('You cannot go that way.');
      return false;
    }
  }

  // Method to pick up an item from the current room
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

  // Method to drop an item from the inventory into the current room
  void dropItem(String itemName) {
    Item? item;
    for (var i in inventory) {
      if (i.name.toLowerCase() == itemName.toLowerCase()) {
        item = i;
        break;
      }
    }

    if (item != null) {
      inventory.remove(item);
      currentRoom.items.add(item);
      print('You dropped: ${item.name}');
    } else {
      print('No such item in your inventory.');
    }
  }

  // Method to inspect an item in the inventory
  void inspectItem(String itemName) {
    Item? item;
    for (var i in inventory) {
      if (i.name.toLowerCase() == itemName.toLowerCase()) {
        item = i;
        break;
      }
    }

    if (item != null) {
      print('Inspecting item: ${item.name}\n${item.description}');
    } else {
      print('No such item in your inventory.');
    }
  }

  // Method to show the player's inventory
  void showInventory() {
    print('Your inventory: ${inventory.map((item) => item.name).join(', ')}');
  }

  // Method to check if the player has a specific item in the inventory
  bool hasItem(String itemName) {
    return inventory.any((item) => item.name.toLowerCase() == itemName.toLowerCase());
  }
}
