class Item {
  String name;
  String description;

  Item(this.name, this.description);

  @override
  String toString() {
    return '$name: $description';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && name.toLowerCase() == other.name.toLowerCase();

  @override
  int get hashCode => name.toLowerCase().hashCode;
}
