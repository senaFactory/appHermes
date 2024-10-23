class Equipment {
  final String type;
  final String brand;
  final String model;
  final String color;
  final String serialNumber;

  Equipment({
    required this.type,
    required this.brand,
    required this.model,
    required this.color,
    required this.serialNumber,
  });

  // Método fromJson para convertir JSON a un objeto Equipment
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      type: json['type'] ?? 'N/A',
      brand: json['brand'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      color: json['color'] ?? 'N/A',
      serialNumber: json['serialNumber'] ?? 'N/A',
    );
  }
}
