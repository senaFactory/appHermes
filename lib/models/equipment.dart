class Equipment {
  final int? id; // ID del equipo (puede ser null si es un nuevo registro)
  final int personId; // ID de la persona asociada
  final String brand;
  final String model;
  final String color;
  final String serialNumber;
  final bool state;

  Equipment({
    this.id, // ID opcional para un nuevo registro
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
      id: json['id'], // Asignar ID si está presente en la respuesta
      personId: json['person_id'] ?? 0, // Asegurar que person_id no sea null
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
      'person_id': personId, // El ID de la persona para asociar el equipo
      'brand': brand,
      'serial': serialNumber,
      'model': model,
      'color': color,
      'state': state,
    };
  }
}
