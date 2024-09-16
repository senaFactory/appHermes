import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';
import 'package:maqueta/pages/pagesSecondarys/formAddEquipts.dart';
import 'package:maqueta/pages/pagesSecondarys/editEquipt.dart';
import 'package:maqueta/widgets/equiptCard.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  // Instancia del modal de edición
  final EditEquiptModal editEquiptModal = EditEquiptModal();

  // Método para manejar la acción de desactivar
  void _deactivateEquipment() {
    // Implementar la lógica para desactivar aquí
    print('Equipo desactivado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const HomeAppBar(),
          const SizedBox(height: 40), // Espacio después de la AppBar
          Center(
            child: Column(
              children: [
                const Text(
                  "Mis Equipos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00314D),
                  ),
                ),
                const SizedBox(height: 20),
                // Tarjeta de equipo reutilizable
                EquipmentCard(
                  type: 'Laptop',
                  brand: 'Lenovo',
                  model: 'Ideapad1',
                  color: 'Azul oscuro',
                  serialNumber: 'ABC1234456789',
                  onEdit: () {
                    editEquiptModal.showEditModal(context);  // Abrir modal de edición
                  },
                  onDeactivate: _deactivateEquipment,  // Llamar a la función de desactivar
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Alinea a la derecha
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Formaddeequipts()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00314D),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
