import 'package:flutter/material.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/pages/equipment/add_equipment_page.dart';
import 'package:maqueta/pages/equipment/edit_equipment_page.dart';
import 'package:maqueta/services/equipment_service.dart';
import 'package:maqueta/services/card_service.dart';
import 'package:maqueta/widgets/equipment_card.dart';
import 'package:maqueta/widgets/home_app_bar.dart';

class Equipmentspage extends StatefulWidget {
  final Equipment? newEquipment;
  const Equipmentspage({super.key, this.newEquipment});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  final CardService _peopleService = CardService();
  final EquipmentService _equipmentService = EquipmentService();
  final List<Equipment> _equipments = [];

  @override
  void initState() {
    super.initState();
    _fetchAllEquipment();
  }

  Future<void> _fetchAllEquipment() async {
    final allEquipment = await _peopleService.getUser();
    setState(() {
      _equipments.clear();
      if (allEquipment != null) {
        _equipments.addAll(allEquipment.equipments);
      }
    });
  }

  Future<void> _toggleEquipmentState(Equipment equipment) async {
    equipment.state = !(equipment.state == true); // Cambia el estado
    print(
        "Nuevo estado del equipo: ${equipment.state}"); // Verifica el nuevo estado

    try {
      await _equipmentService.editEquipment(equipment);
      print("Equipo actualizado en el servidor");
      await _fetchAllEquipment(); // Actualiza la lista en la interfaz
    } catch (e) {
      print("Error al actualizar el estado del equipo: $e");
    }
  }

  Future<void> _navigateToAddEquipmentPage() async {
    final newEquipment = await Navigator.push<Equipment>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEquipmentPage(),
      ),
    );

    if (newEquipment != null) {
      setState(() {
        _equipments.add(newEquipment);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),
            const SizedBox(height: 20),
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
                    onPressed: _navigateToAddEquipmentPage,
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
              child: RefreshIndicator(
                onRefresh: _fetchAllEquipment,
                child: _equipments.isEmpty
                    ? _buildEmptyEquipmentView()
                    : _buildEquipmentList(),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyEquipmentView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "No tienes equipos registrados.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEquipmentList() {
    return ListView.builder(
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
            isActive: equipment.state == true,
            onEdit: () {
              EditEquiptModal(
                initialColor: equipment.color,
                initialSerial: equipment.serial,
                onSave: (newColor, newSerial) async {
                  try {
                    equipment.color = newColor;
                    equipment.serial = newSerial;
                    await _equipmentService.editEquipment(equipment);
                    await _fetchAllEquipment();
                  } catch (e) {
                    print("Error al actualizar el equipo: $e");
                  }
                },
              ).showEditModal(context);
            },
            onDeactivate: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      equipment.state == true
                          ? 'Desactivar equipo'
                          : 'Activar equipo',
                    ),
                    content: Text(
                      equipment.state == true
                          ? '¿Estás seguro de que deseas desactivar este equipo?'
                          : '¿Estás seguro de que deseas activar este equipo?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                           print("Confirmación de ${equipment.state == true ? 'desactivación' : 'activación'} recibida");
                          Navigator.of(context)
                              .pop(); // Cierra el diálogo primero
                          await _toggleEquipmentState(
                              equipment); // Luego ejecuta la función asincrónica
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
