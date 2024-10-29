class Equipment {
  final int id;
  final int? personId;
  final String brand;
  final String model;
  final String color;
  final String serial;
  final bool state;

  Equipment({
    required this.id,
    this.personId,
    required this.brand,
    required this.model,
    required this.color,
    required this.serial,
    required this.state,
  });

  // Convertir JSON a objeto Equipment
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      brand: json['brand'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      color: json['color'] ?? 'N/A',
      serial: json['serial'] ?? 'N/A',
      state: json['state'] ?? false,
    );
  }

  // Convertir objeto Equipment a JSON para registrar
  Map<String, dynamic> toJson() {
    return {
      'person_id': personId,
      'brand': brand,
      'serial': serial,
      'model': model,
      'color': color,
      'state': state,
    };
  }
}
