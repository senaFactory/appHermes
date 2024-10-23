class Equipment {
  final String brand;
  final String model;
  final String color;
  final String serialNumber;
  final String state;

  Equipment({
    required this.brand,
    required this.model,
    required this.color,
    required this.serialNumber,
    required this.state,
  });

  // Convertir JSON a objeto Equipment
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      brand: json['brand'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      color: json['color'] ?? 'N/A',
      serialNumber: json['serial'] ?? 'N/A',
      state: json['state'] ?? true,
    );
  }

  // Convertir objeto Equipment a JSON
  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'serial': serialNumber,
      'model': model,
      'color': color,
      'state': state,
    };
  }
}
