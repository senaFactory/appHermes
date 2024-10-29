import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:maqueta/models/user.dart';

class QrModal extends StatelessWidget {
  final User user;

  const QrModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: PrettyQrView.data(
        data: '${[
          user.name,
          user.lastName,
          user.email,
          user.documentNumber,
          user.acronym,
          user.bloodType,
          user.studySheet,
          user.program,
          user.journal,
          user.trainingCenter
        ]}',
        decoration: const PrettyQrDecoration(
          background: Colors.white,
          shape: PrettyQrSmoothSymbol(color: Colors.black),
          image: PrettyQrDecorationImage(
            image: AssetImage('images/logo_sena_negro.png'),
          ),
        ),
        errorCorrectLevel: QrErrorCorrectLevel.M,
      ),
    );
  }
}
