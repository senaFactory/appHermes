// custom_dropdown.dart
import 'package:flutter/material.dart';

//* Widget para personalizar el menu desplegable de los formularios 

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(color: Colors.grey)),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 16, color: Colors.black)),
        );
      }).toList(),
      onChanged: onChanged,
      // Estilo del Dropdown
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,  // Cambia el icono de la flecha hacia abajo
        color: Colors.grey,
      ),
      style: const TextStyle(
        color: Colors.black,  // Estilo del texto seleccionado
        fontSize: 16,
      ),
      dropdownColor: Colors.white,  // Color de fondo del desplegable
      isExpanded: true,  // Para que ocupe todo el ancho disponible
    );
  }
}
