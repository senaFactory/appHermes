import 'package:flutter/material.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Equipmentspage extends StatefulWidget {
  const Equipmentspage({super.key});

  @override
  State<Equipmentspage> createState() => _EquipmentspageState();
}

class _EquipmentspageState extends State<Equipmentspage> {
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
                    color: Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.laptop, size: 30, color: Colors.black54),
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
                                    "Asus Vibabook",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Botón desplegable
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                value: "Acción",
                                child: Text("Acción"),
                              ),
                              DropdownMenuItem<String>(
                                value: "Editar",
                                child: Text("Editar"),
                              ),
                              DropdownMenuItem<String>(
                                value: "Eliminar",
                                child: Text("Eliminar"),
                              ),
                            ],
                            onChanged: (value) {},
                            icon: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.label, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Ideapad1",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.color_lens, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            "Azul oscuro",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
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
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Botón "Agregar equipo"
                ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00314D),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Agregar equipo"),
                
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
