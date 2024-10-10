import 'package:flutter/material.dart';
import 'package:maqueta/pages/equipment/edit_equipment_page.dart';
import 'package:maqueta/widgets/home_app_bar.dart';
import 'package:maqueta/pages/equipment/add_equipment_page.dart';
import 'package:maqueta/widgets/equipment_card.dart';
import 'package:maqueta/models/equipment.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  final EditEquiptModal editEquiptModal = EditEquiptModal();
  List<Equipment> _equipments = [];

  void _deactivateEquipment() {
    print('Equipo desactivado');
  }

  void _addEquipment(Equipment equipment) {
    setState(() {
      _equipments.add(equipment);
    });
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
                    color: Color(0xFF00314D),
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
                      _addEquipment(newEquipment);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00314D),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Agregar equipo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
                    type: equipment.type,
                    brand: equipment.brand,
                    model: equipment.model,
                    color: equipment.color,
                    serialNumber: equipment.serialNumber,
                    onEdit: () {
                      editEquiptModal.showEditModal(context);
                    },
                    onDeactivate: _deactivateEquipment,
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
