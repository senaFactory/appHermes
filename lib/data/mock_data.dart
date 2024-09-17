import 'package:maqueta/models/user.dart';
import 'package:maqueta/models/equipment.dart';

//* Datos simulados del usuario y equipos

List<Equipment> mockEquipments = [
  Equipment(
    type: "Laptop",
    brand: "Lenovo",
    model: "Ideapad1",
    color: "Azul oscuro",
    serialNumber: "ABC1234456789",
  ),
  Equipment(
    type: "Tablet",
    brand: "Apple",
    model: "iPad Air",
    color: "Plateado",
    serialNumber: "XYZ987654321",
  ),
];

final mockUser = User(
  name: 'Juan Pedro',
  lastName: 'Navaja Laverde',
  documentType: 'C.C',
  documentNumber: '1032937844',
  bloodType: 'O+',
  email: 'juanpedro@gmail.com',
  phoneNumber: '3223909096',
  birthDate: DateTime(2000, 12, 28),
  fichaNumber: '2620620',           //* Agregado el número de ficha
  trainingCenter: 'Centro de Servicios Financieros', //* Agregado el centro de formación
  equipments: [],                    //* Inicialmente sin equipos
);

