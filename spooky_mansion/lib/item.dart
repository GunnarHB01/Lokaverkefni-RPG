class Item {
  String name;
  String description;

  Item(this.name, this.description);

  @override
  String toString() {
    return '$name: $description';
  }
}
