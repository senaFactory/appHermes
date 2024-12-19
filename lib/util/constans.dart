class AppConstants {
  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  final Map<String, int> typeDocument = {
    "T.I": 1,
    "C.C": 2,
    "C.E": 3,
    "P.E.P": 4,
    "P.P.T": 5,
  };

  static const Set<String> documentType = {
    'Cédula de Ciudadanía',
    'Tarjeta de Identidad',
    'Cédula de Extranjeria',
    'Permiso especial de permanencía',
    'Permiso de protección temporal',
  };
}
