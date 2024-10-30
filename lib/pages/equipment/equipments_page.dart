import 'package:flutter/material.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/services/people_service.dart';
import 'package:maqueta/widgets/equipment_card.dart';
import 'package:maqueta/widgets/home_app_bar.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  final PeopleService _peopleService = PeopleService();
  final List<Equipment> _equipments = [];

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final jwt = TokenStorage().decodeJwtToken();
    final user = await _peopleService.getUser();
    if (user != null) {
      setState(() {
        _equipments.addAll(user.equipments);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            child: HomeAppBar(),
          ),
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
                  onPressed: () {}, // Llama al método de registro
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
