import 'package:flutter/material.dart';
import 'package:maqueta/pages/pagesSecondarys/formAddEquipts.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // AppBar personalizado
          HomeAppBar(),
          SizedBox(height: 40), // Espacio después de la AppBar
          Center(
            child: Column(
              children: [
                // Título "Mis Equipos"
                Text(
                  "Mis Equipos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00314D),
                  ),
                ),
                SizedBox(height: 20),
                // Tarjeta de equipo
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
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
                            icon: Icon(Icons.keyboard_arrow_down),
                            hint: Text("Acción"),
                            underline: SizedBox(), // Eliminar la línea de subrayado
                            items: [
                              DropdownMenuItem<String>(
                                value: "Editar",
                                child: Text("Editar"),
                              ),
                              DropdownMenuItem<String>(
                                value: "ELiminar",
                                child: Text("Eliminar"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value;
                              });
                            },
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                          ),
                        ],
                      ),
                      Divider(thickness: 1.5, color: Colors.grey[300]),
                      Row(
                        children: [
                          Icon(Icons.label, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Ideapad1",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.color_lens,
                              size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Azul oscuro",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.qr_code, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "ABC1234456789",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
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
                          backgroundColor: Color(0xFF00314D),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
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
