import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final String name;
  final String brand;
  final String model;
  final String color;
  final String serialNumber;
  final bool isActive;
  final VoidCallback? onEdit; // Permite que onEdit sea opcional
  final VoidCallback onDeactivate;

  const EquipmentCard({
    super.key,
    required this.name,
    required this.brand,
    required this.model,
    required this.color,
    required this.serialNumber,
    required this.isActive,
    this.onEdit, // Opcional
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFF5F5F5)
            : Colors.grey.shade300, // Color según el estado
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
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        brand,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              // Menú desplegable con opciones de Editar y Activar/Desactivar
              DropdownButton<String>(
                value: null,
                icon: const Icon(Icons.keyboard_arrow_down),
                hint: Text(
                  isActive ? "Activo" : "Inactivo",
                  style: TextStyle(
                    color: isActive
                        ? Colors.green
                        : Colors.red, // Color según el estado
                    fontWeight: FontWeight.bold,
                  ),
                ),
                underline: const SizedBox(), // Elimina la línea de subrayado
                items: [
                  // Opcional: Mostrar "Editar" solo si `onEdit` no es nulo
                  if (onEdit != null)
                    const DropdownMenuItem<String>(
                      value: "Editar",
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Color(0xFF888787)),
                          SizedBox(width: 10),
                          Text("Editar"),
                        ],
                      ),
                    ),
                  DropdownMenuItem<String>(
                    value: isActive ? "Desactivar" : "Activar",
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.remove_circle : Icons.check_circle,
                          color: isActive ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Text(isActive ? "Desactivar" : "Activar"),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == "Editar" && onEdit != null) {
                    onEdit!(); // Ejecuta onEdit solo si no es nulo
                  } else if (value == "Activar" || value == "Desactivar") {
                    onDeactivate();
                  }
                },
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
