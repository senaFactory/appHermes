import 'package:flutter/material.dart';
import 'package:maqueta/pages/pagesSecondarys/formAddEquipts.dart';
import 'package:maqueta/pages/pagesSecondarys/editEquipt.dart'; 
import 'package:maqueta/widgets/HomeAppBar.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  String? selectedOption;

  // Instancia del modal de edición
  final EditEquiptModal editEquiptModal = EditEquiptModal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // AppBar personalizado
          HomeAppBar(),
          const SizedBox(height: 40), // Espacio después de la AppBar
          Center(
            child: Column(
              children: [
                // Título "Mis Equipos"
                const Text(
                  "Mis Equipos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00314D),
                  ),
                ),
                const SizedBox(height: 20),
                // Tarjeta de equipo
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                            children: const [
                              Icon(Icons.laptop,
                                  size: 30, color: Colors.black54),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Laptop",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Lenovo",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Botón desplegable con "Acción"
                          DropdownButton<String>(
                            value: selectedOption,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            hint: const Text("Acción"),
                            underline: const SizedBox(), // Eliminar la línea de subrayado
                            items: [
                              const DropdownMenuItem<String>(
                                value: "Editar",
                                child: Text("Editar"),
                              ),
                              const DropdownMenuItem<String>(
                                value: "Desactivar",
                                child: Text("Desactivar"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value;
                                if (value == "Editar") {
                                  editEquiptModal.showEditModal(context); // Mostrar el modal
                                }
                              });
                            },
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.5, color: Colors.grey),
                      Row(
                        children: const [
                          Icon(Icons.label, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Ideapad1",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.color_lens,
                              size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Azul oscuro",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.qr_code, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "ABC1234456789",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Alinea a la derecha
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20.0), // Espacio a la derecha
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Formaddeequipts()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00314D),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
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
