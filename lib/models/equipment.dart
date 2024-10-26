class Equipment {
  final int? id; 
  final int personId; 
  final String brand;
  final String model;
  final String color;
  final String serialNumber;
  final bool state;

  Equipment({
    this.id, 
    required this.personId,
    required this.brand,
    required this.model,
    required this.color,
    required this.serialNumber,
    required this.state,
  });

  // Convertir JSON a objeto Equipment
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      personId: json['person_id'] ?? 0, 
      brand: json['brand'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      color: json['color'] ?? 'N/A',
      serialNumber: json['serial'] ?? 'N/A',
      state: json['state'] ?? false,
    );
  }

  // Convertir objeto Equipment a JSON para registrar
  Map<String, dynamic> toJson() {
    return {
      'person_id': personId, 
      'brand': brand,
      'serial': serialNumber,
      'model': model,
      'color': color,
      'state': state,
    };
  }
}
