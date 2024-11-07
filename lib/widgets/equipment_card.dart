import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final String type;
  final String brand;
  final String model;
  final String color;
  final String serialNumber;
  final bool isActive; // Añadido: para verificar si está activo
  final VoidCallback onEdit;
  final VoidCallback onDeactivate;

  const EquipmentCard({
    super.key,
    required this.type,
    required this.brand,
    required this.model,
    required this.color,
    required this.serialNumber,
    required this.isActive, // Añadido: para definir el estado activo/inactivo
    required this.onEdit,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    print("Estado del equipo (isActive) en EquipmentCard: $isActive");
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF5F5F5) : Colors.grey.shade300, // Color según el estado
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.laptop, size: 30, color: Colors.black54),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        brand,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              // Menú desplegable con opciones de Editar y Desactivar
              DropdownButton<String>(
                value: null,
                icon: const Icon(Icons.keyboard_arrow_down),
                hint: const Text("Acción"),
                underline: const SizedBox(), // Elimina la línea de subrayado
                items: [
                  DropdownMenuItem<String>(
                    value: "Editar",
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Color(0xFF888787)), // Ícono de Editar
                        SizedBox(width: 10),
                        Text("Editar"),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "Desactivar",
                    child: Row(
                      children: const [
                        Icon(Icons.circle, color: Color(0xFF888787)), // Ícono de Desactivar
                        SizedBox(width: 10),
                        Text("Desactivar"),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == "Editar") {
                    onEdit(); // Acción de Editar
                  } else if (value == "Desactivar") {
                    onDeactivate(); // Acción de Desactivar
                  }
                },
                dropdownColor: Colors.white, // Color del menú desplegable
                borderRadius: BorderRadius.circular(10), // Bordes redondeados del menú
              ),
            ],
          ),
          const Divider(thickness: 1.5, color: Colors.grey),
          Row(
            children: [
              const Icon(Icons.label, size: 20, color: Colors.black54),
              const SizedBox(width: 5),
              Text(
                model,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.color_lens, size: 20, color: Colors.black54),
              const SizedBox(width: 5),
              Text(
                color,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.qr_code, size: 20, color: Colors.black54),
              const SizedBox(width: 5),
              Text(
                serialNumber,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
