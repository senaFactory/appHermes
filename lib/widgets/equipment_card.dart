import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final String type;
  final String brand;
  final String model;
  final String color;
  final String serialNumber;
  final Function()? onEdit;
  final Function()? onDeactivate;

  const EquipmentCard({
    Key? key,
    required this.type,
    required this.brand,
    required this.model,
    required this.color,
    required this.serialNumber,
    this.onEdit,
    this.onDeactivate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
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
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Menú de opciones (Editar, Desactivar) con estilo personalizado
              Theme(
                data: Theme.of(context).copyWith(
                  // Cambiar el color de fondo y estilo de los ítems del menú
                  cardColor: Colors.white,
                  textTheme: const TextTheme().apply(bodyColor: Color(0xFF00314D)),
                ),
                child: DropdownButton<String>(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF00314D)), // Icono personalizado
                  underline: const SizedBox(), // Eliminar subrayado
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF00314D), // Color del texto en el menú
                  ),
                  dropdownColor: Colors.white, // Color de fondo del menú desplegable
                  items: [
                    DropdownMenuItem<String>(
                      value: "Editar",
                      child: Row(
                        children: const [
                          Icon(Icons.edit, color: Color(0xFF00314D)),
                          SizedBox(width: 8),
                          Text("Editar"),
                        ],
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "Desactivar",
                      child: Row(
                        children: const [
                          Icon(Icons.circle, color: Color.fromARGB(255, 240, 95, 95)),
                          SizedBox(width: 8),
                          Text("Desactivar"),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value == "Editar") {
                      onEdit?.call(); // Llama a la función de editar
                    } else if (value == "Desactivar") {
                      onDeactivate?.call(); // Llama a la función de desactivar
                    }
                  },
                ),
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
