import 'package:flutter/material.dart';
import 'package:maqueta/features/equipment/equipment.dart';
import 'package:maqueta/features/equipment/add_equipment_page.dart';
import 'package:maqueta/features/equipment/edit_equipment_page.dart';
import 'package:maqueta/core/provider/token_storage.dart';
import 'package:maqueta/features/equipment/equipment_service.dart';
import 'package:maqueta/features/carnet/card_service.dart';
import 'package:maqueta/core/wigdets/equipment_card.dart';
import 'package:maqueta/core/wigdets/home_app_bar.dart';

class Equipmentspage extends StatefulWidget {
  final Equipment? newEquipment;
  final String? role;

  const Equipmentspage({super.key, this.newEquipment, required this.role});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  String? userRole; // Variable para almacenar el rol del usuario
  final CardService _peopleService = CardService();
  final EquipmentService _equipmentService = EquipmentService();
  final TokenStorage tokenStorage = TokenStorage();
  final List<Equipment> _equipments = [];

  @override
  void initState() {
    super.initState();
    _getUserRole(); // Obtiene el rol del usuario
    _fetchAllEquipment();
  }

  /// Obtiene el rol del usuario y lo almacena en userRole
  Future<void> _getUserRole() async {
    final role = await tokenStorage.getPrimaryRole();
    setState(() {
      userRole = role;
    });
  }

  /// Obtiene la lista de equipos
  Future<void> _fetchAllEquipment() async {
    final allEquipment = await _peopleService.getUser();
    setState(() {
      _equipments.clear();
      if (allEquipment != null) {
        _equipments.addAll(allEquipment.equipments);
      }
    });
  }

  /// Cambia el estado de activación/inactivación de un equipo
  Future<void> _toggleEquipmentState(Equipment equipment) async {
    equipment.state = !(equipment.state == true); // Cambia el estado
    try {
      await _equipmentService.editEquipment(equipment);
      await _fetchAllEquipment(); // Actualiza la lista en la interfaz
    } catch (e) {
      throw Exception('Failed to get Equipments');
    }
  }

  /// Navega a la pantalla para agregar un equipo
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
                  Text(
                    "Mis Equipos",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  ElevatedButton(
                    onPressed: _navigateToAddEquipmentPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Agregar equipo",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
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
                    ? _buildEmptyEquipmentView(context)
                    : _buildEquipmentList(),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyEquipmentView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_other,
            size: 80,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(height: 20),
          Text(
            "No tienes equipos registrados.",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
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
            name: equipment.name,
            brand: equipment.brand,
            model: equipment.model,
            color: equipment.color,
            serialNumber: equipment.serial,
            isActive: equipment.state == true,

            // Solo muestra el modal de editar si el rol es SUPER ADMIN o ADMIN
            onEdit: (userRole == 'SUPER ADMIN' || userRole == 'ADMIN')
                ? () {
                    EditEquiptModal(
                      initialFields: {
                        "Color": equipment.color,
                        "Serial": equipment.serial,
                        "Tipo": equipment.name,
                        "Marca": equipment.brand,
                        "Modelo": equipment.model,
                      },
                      onSave: (updatedFields) async {
                        try {
                          equipment.color =
                              updatedFields["Color"] ?? equipment.color;
                          equipment.serial =
                              updatedFields["Serial"] ?? equipment.serial;
                          equipment.name =
                              updatedFields["Tipo"] ?? equipment.name;
                          equipment.brand =
                              updatedFields["Marca"] ?? equipment.brand;
                          equipment.model =
                              updatedFields["Modelo"] ?? equipment.model;

                          await _equipmentService.editEquipment(equipment);
                          await _fetchAllEquipment();
                        } catch (e) {
                          throw Exception('Failed to Edit Equipment');
                        }
                      },
                    ).showEditModal(context);
                  }
                : null,

            onDeactivate: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      equipment.state == true
                          ? 'Desactivar equipo'
                          : 'Activar equipo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: equipment.state == true
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    content: Text(
                      equipment.state == true
                          ? '¿Estás seguro de que deseas desactivar este equipo?'
                          : '¿Estás seguro de que deseas activar este equipo?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancelar',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _toggleEquipmentState(equipment);
                        },
                        child: Text(
                          'Confirmar',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
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
