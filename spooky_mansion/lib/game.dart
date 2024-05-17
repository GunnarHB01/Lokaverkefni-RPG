import 'dart:io';
import 'player.dart';
import 'room.dart';
import 'item.dart';

// The Game class handles the overall game logic and flow
class Game {
  late Room startRoom; // The starting room of the game
  late Player player; // The player in the game
  late List<Room> rooms; // A list of all rooms in the game
  late Item key; // The key item for unlocking rooms
  late Room secretRoom; // The secret room in the game
  late Room aWayOut; // The final room that indicates the player has won
  late Room lockedRoom; // Another locked room in the game
  bool gameWon = false; // Indicates if the game has been won

  // Constructor to initialize the game
  Game() {
    initializeGame();
  }

  // Method to set up the game environment
  void initializeGame() {
    Room entrance = Room('Entrance', 'The main entrance of the mansion.');
    Room livingRoom = Room('Living Room', 'A cozy living room with an unlit smoky fireplace.');
    Room kitchen = Room('Kitchen', 'A rather large but empty space for the most part.', hasTrap: true);
    Room library = Room('Library', 'A room full of dusty books and a rather low mysterious pulsing sound.');
    secretRoom = Room('Secret Room', 'A hidden room behind a bookshelf. There seems to be a puzzle here.', isLocked: true, key: Item('Secret Key', 'A key to unlock the SECRET ROOM.'));
    aWayOut = Room('A Way Out', 'You found a way out of the mansion. Congratulations, you won!', isLocked: true);
    lockedRoom = Room('Strange room', 'This is rather small but warmer than the other rooms (you notice a low breathing sound behind the wall).', isLocked: true, key: Item('Key', 'A key to unlock a room.'));

    // Connect rooms together
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

    // Create key items
    key = Item('Key', 'A small rusty key.');
    Item secretKey = Item('Secret Key', 'A key to unlock the secret room.');
    Item trapDefuser = Item('Trap Defuser', 'A device to defuse traps.');

    // Add rooms to the list of rooms
    rooms = [entrance, livingRoom, kitchen, library, secretRoom, aWayOut, lockedRoom];

    // Place items in rooms
    library.items.add(secretKey);
    livingRoom.items.add(trapDefuser);
    entrance.items.add(key);

    // Set the starting room and create the player
    startRoom = entrance;
    player = Player('Player', startRoom);
    startRoom.discovered = true;
    player.discoveredRooms.add(startRoom.name.toLowerCase());
  }

  // Method to start the game
  void start() {
    print('\nWelcome to the Spooky Mansion!');
    print(player.currentRoom);

    while (!gameWon) {
      print('\n--------------------------');
      print('What do you want to do?');
      print('1. Interact with Item');
      print('2. Move to next room');
      print('3. Show inventory');
      print('4. Look around');
      print('5. Exit');
      print('--------------------------');

      // Read player input
      String? input = stdin.readLineSync();
      if (input == null) continue;

      // Handle player input
      switch (input) {
        case '1':
          interactWithItem();
          break;
        case '2':
          showAvailableRooms();
          print('Enter the direction or room name you want to move to:');
          String? directionOrRoom = stdin.readLineSync();
          if (directionOrRoom != null) {
            bool hasTrap = player.move(directionOrRoom);
            if (hasTrap) {
              handleTrapRoom();
            }
            if (player.currentRoom == aWayOut) {
              if (!gameWon) {
                print(aWayOut.description);
                gameWon = true;
              }
              return;
            }
            if (player.currentRoom == secretRoom) {
              offerPuzzle();
            }
          }
          break;
        case '3':
          player.showInventory();
          break;
        case '4':
          print(player.currentRoom);
          break;
        case '5':
          print('Thanks for playing!');
          return;
        default:
          print('Invalid command.');
      }
    }
  }

  // Method to show available rooms and directions from the current room
  void showAvailableRooms() {
    print('Available rooms or directions:');
    player.currentRoom.connections.forEach((direction, room) {
      if (room.discovered) {
        print('${room.name}');
      } else {
        print('$direction');
      }
    });
  }

  // Method to handle interactions with items
  void interactWithItem() {
    while (true) {
      print('\n--------------------------');
      print('What do you want to do?');
      print('1. Pick up item');
      print('2. Drop item');
      print('3. Inspect item');
      print('4. Back');
      print('--------------------------');

      // Read player input for item interaction
      String? input = stdin.readLineSync();
      if (input == null) continue;

      // Handle item interaction input
      switch (input) {
        case '1':
          print('Enter the name of the item you want to pick up:');
          String? itemName = stdin.readLineSync();
          if (itemName != null) {
            player.pickUpItem(itemName);
          }
          break;
        case '2':
          print('Enter the name of the item you want to drop:');
          String? itemName = stdin.readLineSync();
          if (itemName != null) {
            player.dropItem(itemName);
          }
          break;
        case '3':
          print('Enter the name of the item you want to inspect:');
          String? itemName = stdin.readLineSync();
          if (itemName != null) {
            player.inspectItem(itemName);
          }
          break;
        case '4':
          return; // Back to the main menu
        default:
          print('Invalid command.');
      }
    }
  }

  // Method to handle trap rooms
  void handleTrapRoom() {
    print('You entered the kitchen and triggered a trap!');
    if (player.hasItem('Trap Defuser')) {
      print('You used the Trap Defuser to safely defuse the trap.');
      player.currentRoom.hasTrap = false;
    } else {
      print('You do not have the Trap Defuser. Find it to defuse the trap.');
      print('If you attempt to leave the kitchen without defusing the trap, you will die.');
      while (true) {
        print('Do you want to leave the kitchen? (yes/no)');
        String? input = stdin.readLineSync();
        if (input == 'yes') {
          print('You tried to leave the kitchen without defusing the trap and died.');
          exit(0);
        } else if (input == 'no') {
          print('You must stay in the kitchen until you find the Trap Defuser.');
        } else {
          print('Invalid command.');
        }
      }
    }
  }

  // Method to offer a puzzle in the secret room
  void offerPuzzle() {
    while (true) {
      print('You are in the secret room. There is a puzzle here.');
      print('Do you want to try to solve the puzzle? (yes/no)');
      String? input = stdin.readLineSync();
      if (input == 'yes') {
        puzzleInSecretRoom();
        return;
      } else if (input == 'no') {
        return;
      } else {
        print('Invalid command.');
      }
    }
  }

  // Method to handle the puzzle in the secret room
  void puzzleInSecretRoom() {
    print('Solve the puzzle to unlock "A Way Out".');
    print('What is 2 + 2?');
    String? answer = stdin.readLineSync();
    if (answer == '4') {
      print('Correct! You unlocked "A Way Out".');
      secretRoom.connectRoom('north', aWayOut);
      aWayOut.connectRoom('south', secretRoom);
      aWayOut.isLocked = false;
    } else {
      print('Incorrect answer. Try again later.');
    }
  }
}
