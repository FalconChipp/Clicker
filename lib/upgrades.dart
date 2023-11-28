class Upgrade {
  String name;
  double cost;
  int value;
  int count;
  String description;

  Upgrade({
    required this.name,
    required this.cost,
    required this.value,
    required this.description,
    this.count = 0,
  });
}

List<Upgrade> upgradesData = [
  Upgrade(name: 'Upgrade 1', cost: 10.0, value: 1, description: 'This is a description'),
  Upgrade(name: 'Upgrade 2', cost: 20.0, value: 2, description: 'This is a description'),
  Upgrade(name: 'Upgrade 3', cost: 30.0, value: 3, description: 'This is a description'),
];
