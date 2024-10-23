import 'package:flutter/material.dart';
import 'package:maqueta/pages/equipment/edit_equipment_page.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/pages/equipment/add_equipment_page.dart';
import 'package:maqueta/widgets/equipment_card.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/services/equipment_service.dart'; // Importar el servicio

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  final EditEquiptModal editEquiptModal = EditEquiptModal();
  final EquipmentService _equipmentService = EquipmentService(); // Instancia del servicio
  List<Equipment> _equipments = []; // Lista de equipos

  @override
  void initState() {
    super.initState();
    _fetchEquipments(); // Cargar los equipos al iniciar
  }

  // Método para obtener los equipos desde la API
  Future<void> _fetchEquipments() async {
    try {
      final equipments = await _equipmentService.getAllEquipments();
      setState(() {
        _equipments = equipments;
      });
    } catch (e) {
      print('Error fetching equipments: $e');
    }
  }

  // Método para agregar un equipo nuevo a través de la API
  Future<void> _addEquipment(Equipment equipment) async {
    try {
      await _equipmentService.addEquipment(equipment);
      _fetchEquipments(); // Recargar los equipos después de agregar
    } catch (e) {
      print('Error adding equipment: $e');
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
                  onPressed: () async {
                    final newEquipment = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Formaddeequipts(),
                      ),
                    );

                    if (newEquipment != null) {
                      await _addEquipment(newEquipment); // Agregar equipo a la API
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39A900),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    serialNumber: equipment.serialNumber,
                    onEdit: () {
                      editEquiptModal.showEditModal(context);
                    },
                    onDeactivate: () {
                      print('Equipo desactivado');
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
