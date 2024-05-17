// The Item class represents items that can be found and used in the game
class Item {
  String name; // The name of the item
  String description; // A description of the item

  // Constructor to create an item with a name and description
  Item(this.name, this.description);

  // Override the toString method to return a string representation of the item
  @override
  String toString() {
    return '$name: $description';
  }

  // Override the equality operator to compare items based on their name (case insensitive)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && name.toLowerCase() == other.name.toLowerCase();

  // Override the hashCode method to generate a hash code based on the item's name (case insensitive)
  @override
  int get hashCode => name.toLowerCase().hashCode;
}
