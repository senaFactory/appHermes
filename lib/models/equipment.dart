class Equipment {
  final int? id;
  String? document;
  final String brand;
  final String model;
  final String color;
  final String serial;
  final bool state;

  Equipment({
    this.id,
    this.document,
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
      'document': document,
      'brand': brand,
      'serial': serial,
      'model': model,
      'color': color,
      'state': state,
    };
  }

  set setDocumentId(String idValue) {
    document = idValue;
  }
}
