import 'package:flutter/material.dart';

import 'package:map2/app/domain/ui/pages/reservation_page.dart'; // Ajusta la importación según tu estructura

class ReservasAdquiridasPage extends StatelessWidget {
  final SportsCourt selectedCourt;

  const ReservasAdquiridasPage({Key? key, required this.selectedCourt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas Adquiridas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Has reservado la cancha:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              selectedCourt.nombre,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              selectedCourt.descripcion,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == '/');
              },
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
