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
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context)
                .colorScheme
                .secondary
                .withOpacity(0.8), // Fondo dinámico
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.miscellaneous_services,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        brand,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              // Menú desplegable con opciones de Editar y Activar/Desactivar
              DropdownButton<String>(
                value: null,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).iconTheme.color,
                ),
                hint: Text(
                  isActive ? "Activo" : "Inactivo",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                underline: const SizedBox(), // Elimina la línea de subrayado
                items: [
                  // Opcional: Mostrar "Editar" solo si `onEdit` no es nulo
                  if (onEdit != null)
                    DropdownMenuItem<String>(
                      value: "Editar",
                      child: Row(
                        children: [
                          Icon(Icons.edit,
                              color: Theme.of(context).colorScheme.onSurface),
                          const SizedBox(width: 10),
                          Text(
                            "Editar",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  DropdownMenuItem<String>(
                    value: isActive ? "Desactivar" : "Activar",
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.remove_circle : Icons.check_circle,
                          color: isActive
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isActive ? "Desactivar" : "Activar",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
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
                dropdownColor: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
          const Divider(
            thickness: 2.5,
            color: Color.fromARGB(255, 1, 1, 1),
          ),
          Row(
            children: [
              Icon(Icons.label,
                  size: 20, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 5),
              Text(
                model,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 15),
              Icon(Icons.color_lens,
                  size: 20, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 5),
              Text(
                color,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.qr_code,
                  size: 20, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 5),
              Text(
                serialNumber,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
