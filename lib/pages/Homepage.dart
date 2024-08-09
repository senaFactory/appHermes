import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maqueta/widgets/HomeAppBar.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          HomeAppBar(),
          Container(
            child: Column(
              children:[
                SizedBox(height: 70), //Espacio entre el titulo y el texto
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Mis Equipos",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // Grosor del texto
                        color: Color(0xFF00314D),
                        height: 1.0, // Ajusta la altura de línea para reducir el espacio vertical
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F4F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.laptop, color: Colors.black),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Laptop",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text("Lenovo"),
                                    ],
                                  ),
                                ],
                              ),
                               DropdownButton<String>(
                                value: "Accion",
                                onChanged: (String? newValue) {},
                                items: <String>['Accion', 'Opción 1', 'Opción 2']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                                );
                                }).toList(),
                              ),
                            ],
                          ),
                          Divider(color: Colors.black),
                          Row(
                            children: [
                              Icon(Icons.tag, color: Colors.black,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],

      //* NavBar
      
      ),
      bottomNavigationBar:CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        onTap: (index){},
        height: 70,
        color: Color(0xFF00314D),
        buttonBackgroundColor: Color(0xFF007D78),
        items:[
          Icon(
            Icons.computer,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.qr_code,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.people_alt_outlined,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),

    );
  }
}
