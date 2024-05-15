import 'dart:io';
import 'player.dart';
import 'room.dart';

class Game {
  late Room startRoom;
  late Player player;

  Game() {
    initializeGame();
  }

  void initializeGame() {
    Room entrance = Room('Entrance', 'The main entrance of the mansion.');
    Room livingRoom = Room('Living Room', 'A cozy living room with a smoking fireplace.');

    entrance.connectRoom('north', livingRoom);
    livingRoom.connectRoom('south', entrance);

    startRoom = entrance;
    player = Player('Player', startRoom);
  }

  void start() {
    print('Welcome to the Spooky Mansion!');
    print(player.currentRoom);

    while (true) {
      print('\nWhat do you want to do?');
      print('1. Move to next room');
      print('2. Exit');

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
          print('Thanks for playing!');
          return;
        default:
          print('Invalid command.');
      }
    }
  }
}
