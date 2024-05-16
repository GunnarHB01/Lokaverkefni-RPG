import 'dart:io';
import 'player.dart';
import 'room.dart';
import 'item.dart';

class Game {
  late Room startRoom;
  late Player player;
  late List<Room> rooms;
  late Item key;
  late Room secretRoom;
  late Room aWayOut;
  late Room lockedRoom;

  Game() {
    initializeGame();
  }

  void initializeGame() {
    Room entrance = Room('Entrance', 'The main entrance of the mansion.');
    Room livingRoom = Room('Living Room', 'A cozy living room with an unlit smoky fireplace.');
    Room kitchen = Room('Kitchen', 'A rather large but empty space for the most part.');
    Room library = Room('Library', 'A room full of dusty books and a rather low mysterious pulsing sound.');
    secretRoom = Room('Secret Room', 'A hidden room behind a bookshelf. There seems to be a puzzle here.', isLocked: true, key: Item('Secret Key', 'A key to unlock the SECRET ROOM.'));
    aWayOut = Room('A Way Out', 'You found a way out of the mansion. Congratulations, you won!', isLocked: true);
    lockedRoom = Room('Strange room', 'This is rather small but warmer than the other rooms (you notice a low breathing sound behind the wall).', isLocked: true, key: Item('Key', 'A key to unlock a room.'));

    entrance.connectRoom('north', livingRoom);
    livingRoom.connectRoom('south', entrance);
    livingRoom.connectRoom('east', kitchen);
    kitchen.connectRoom('west', livingRoom);
    livingRoom.connectRoom('west', library);
    library.connectRoom('east', livingRoom);
    library.connectRoom('north', secretRoom);
    secretRoom.connectRoom('south', library);
    entrance.connectRoom('east', lockedRoom);
    lockedRoom.connectRoom('west', entrance);

    key = Item('Key', 'A small rusty key.');
    Item secretKey = Item('Secret Key', 'A key to unlock the secret room.');

    rooms = [entrance, livingRoom, kitchen, library, secretRoom, aWayOut, lockedRoom];

    library.items.add(secretKey);
    entrance.items.add(key);

    startRoom = entrance;
    player = Player('Player', startRoom);
  }

  void start() {
    print('Welcome to the Spooky Mansion!');
    print(player.currentRoom);

    while (true) {
      print('\nWhat do you want to do?');
      print('1. Move to next room');
      print('2. Pick up item');
      print('3. Show inventory');
      print('4. Exit');
      print('--------------------------');
      print('Available directions:');
      player.showAvailableDirections();
      print('--------------------------');

      String? input = stdin.readLineSync();
      if (input == null) continue;

      switch (input) {
        case '1':
          print('Enter the direction you want to move:');
          String? direction = stdin.readLineSync();
          if (direction != null) {
            player.move(direction);
          }
          break;
        case '2':
          print('Enter the name of the item you want to pick up:');
          String? itemName = stdin.readLineSync();
          if (itemName != null) {
            player.pickUpItem(itemName);
          }
          break;
        case '3':
          player.showInventory();
          break;
        case '4':
          print('Thanks for playing!');
          return;
        default:
          print('Invalid command.');
      }
    }
  }
}
