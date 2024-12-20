class Equipment {
  final int? id;
  String? document;
  String brand;
  String model;
  String color;
  bool location; // Cambiado a bool
  String serial;
  bool state; // Cambiado a bool

  Equipment({
    this.id,
    this.document,
    required this.brand,
    required this.model,
    required this.color,
    required this.serial,
    required this.location,
    required this.state,
  });

  // Convertir JSON a objeto Equipment
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      brand: json['brand'] ?? 'N/A',
      model: json['model'] ?? 'N/A',
      color: json['color'] ?? 'N/A',
      location: json['location'] == true ||
          json['location'] == "true", // Asegúrate de que el valor sea booleano
      serial: json['serial'] ?? 'N/A',
      state: json['state'] == true ||
          json['state'] == "true", // Asegúrate de que el valor sea booleano
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
      'location': location, // Enviar como bool
      'state': state.toString(), // Convertir a string en backend
    };
  }

  set setDocumentId(String idValue) {
    document = idValue;
  }
}
