import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:map2/app/domain/clases/Usuario.dart';
import 'package:map2/app/domain/ui/pages/reservasAdquiridaspage.dart';

// Ajusta la importación según tu estructura

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<SportsCourt> canchas = [];
  List<SportsCourt> filteredCanchas = [];
  double maxPrice = 100.0;

  @override
  void initState() {
    super.initState();
    fetchCanchas();
  }

  // Fetch sports courts from the server
  Future<void> fetchCanchas() async {
    final url = Uri.parse('http://10.0.2.2:3000/canchas');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          canchas = (json.decode(response.body) as List)
              .map((e) => SportsCourt.fromMap(e))
              .toList();
          filteredCanchas = canchas;
        });
      } else {
        _showSnackBar('Error al cargar las canchas');
      }
    } catch (e) {
      _showSnackBar('Error al conectar con el servidor');
    }
  }

  // Make a reservation for a sports court
  Future<void> reservarCancha(int canchaId) async {
    final url = Uri.parse('http://10.0.2.2:3000/reservas');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'canchaId': canchaId,
          'fecha': DateTime.now().toIso8601String(),
          'duracion': 60,
          'precioTotal': 50.0,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        SportsCourt selectedCourt =
            canchas.firstWhere((court) => court.id == canchaId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservasAdquiridasPage(
              selectedCourt: selectedCourt,
            ),
          ),
        );

        _showSnackBar('Reserva realizada correctamente');
      } else {
        _showSnackBar('Error al realizar la reserva');
      }
    } catch (e) {
      _showSnackBar('Error al conectar con el servidor');
    }
  }

  // Filter sports courts based on the search query and price
  void filterCanchas(String query, double maxPrice) {
    final filtered = canchas.where((court) {
      final courtName = court.nombre.toLowerCase();
      final courtLocation = court.descripcion.toLowerCase();
      final input = query.toLowerCase();

      return (courtName.contains(input) || courtLocation.contains(input)) &&
          court.price <= maxPrice;
    }).toList();

    setState(() {
      filteredCanchas = filtered;
    });
  }

  // Display a snackbar with a message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Canchas Deportivas'),
        actions: [
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 10),
            child: TextField(
              onChanged: (value) {
                filterCanchas(value, maxPrice);
              },
              decoration: InputDecoration(
                hintText: 'Buscar',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Buscar Canchas Deportivas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Filtrar por precio: \$${maxPrice.toStringAsFixed(0)}'),
            Slider(
              value: maxPrice,
              min: 0,
              max: 200,
              divisions: 20,
              label: maxPrice.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  maxPrice = value;
                });
                filterCanchas('', maxPrice);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCanchas.length,
                itemBuilder: (context, index) {
                  final court = filteredCanchas[index];
                  return _buildCourtCard(context, court);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a card widget for a sports court
  Widget _buildCourtCard(BuildContext context, SportsCourt court) {
    return GestureDetector(
      onTap: () {
        _showCourtDetailsDialog(context, court);
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                court.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                court.descripcion,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Precio: \$${court.price}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Disponibilidad: Libre',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a dialog with details of a sports court
  void _showCourtDetailsDialog(BuildContext context, SportsCourt court) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                court.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Ubicación: ${court.descripcion}'),
              const SizedBox(height: 8),
              Text('Precio: \$${court.price}'),
              const SizedBox(height: 8),
              const Text('Disponibilidad: ocupado'),
              const SizedBox(height: 8),
              Text('Precio: \$${court.image}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      reservarCancha(
                          court.id); // Reserva la cancha seleccionada
                      Navigator.of(context).pop();
                    },
                    child: const Text('Reservar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Model class for SportsCourt
class SportsCourt {
  final int id;
  final String nombre;
  final String descripcion;
  final String image;
  final int price;

  SportsCourt({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.image,
    required this.price,
  });

  factory SportsCourt.fromMap(Map<String, dynamic> map) {
    return SportsCourt(
      id: map['id'] as int,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      image: map['imagen'] as String,
      price: map['precio'] as int,
    );
  }
}