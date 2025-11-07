class Equipment {
  final int? id;
  String? document;
  String name;
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
    required this.name,
  });

  // Convertir JSON a objeto Equipment
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'] ?? 'N/A',
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
      'name': name,
      'brand': brand,
      'serial': serial,
      'model': model,
      'color': color,
      // Enviar booleanos tal cual (mejor práctica) — el backend debería aceptar booleans.
      'location': location,
      'state': state,
    };
  }

  set setDocumentId(String idValue) {
    document = idValue;
  }
}
