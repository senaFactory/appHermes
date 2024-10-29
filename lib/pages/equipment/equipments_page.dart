import 'package:flutter/material.dart';
import 'package:maqueta/services/equipment_service.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/widgets/equipment_card.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/pages/equipment/add_equipment_page.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  final EquipmentService _equipmentService = EquipmentService();
  List<Equipment> _equipments = [];

  @override
  void initState() {
    super.initState();
    _fetchEquipments(); // Cargar equipos al iniciar
  }

  // Función para obtener equipos del usuario con ID 1
  Future<void> _fetchEquipments() async {
    try {
      final equipments = await _equipmentService.getEquipmentsByPersonId(1);
      setState(() {
        _equipments = equipments;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Método para registrar un nuevo equipo y actualizar la lista
  Future<void> _registerEquipment() async {
    final newEquipment = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Formaddeequipts()),
    );

    if (newEquipment != null) {
      newEquipment.personId = 1; // Asignamos el ID 1 a la persona

      await _equipmentService
          .addEquipment(newEquipment); // Registramos el equipo
      _fetchEquipments(); // Actualizamos la lista de equipos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomeAppBar(),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mis Equipos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF39A900),
                  ),
                ),
                ElevatedButton(
                  onPressed: _registerEquipment, // Llama al método de registro
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39A900),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Agregar equipo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _equipments.length,
              itemBuilder: (context, index) {
                final equipment = _equipments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: EquipmentCard(
                    type: equipment.model,
                    brand: equipment.brand,
                    model: equipment.model,
                    color: equipment.color,
                    serialNumber: equipment.serial,
                    onEdit: () {
                      // Lógica para editar equipo
                    },
                    onDeactivate: () {
                      // Lógica para desactivar equipo
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
