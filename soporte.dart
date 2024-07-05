import 'package:flutter/material.dart';

class ContactInfo {
  final String phoneNumber;
  final String emailAddress;

  ContactInfo({
    required this.phoneNumber,
    required this.emailAddress,
  });
}

final ContactInfo contactInfo = ContactInfo(
  phoneNumber: '+1 234 567 890',
  emailAddress: 'Pichangasya@gmail.com',
);

class SoportePage extends StatefulWidget {
  const SoportePage({Key? key}) : super(key: key);

  @override
  _SoportePageState createState() => _SoportePageState();
}

class _SoportePageState extends State<SoportePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String email = _emailController.text;
      final String message = _messageController.text;

      // Ejemplo: enviar datos al servidor o mostrar un mensaje de éxito
      print('Nombre: $name, Correo Electrónico: $email, Mensaje: $message');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¡Muchas gracias por tu continuo apoyo!'),
            content: Text('Se registraron los datos correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/images/logo.jpeg'), // Agrega la imagen de la empresa aquí
                ),
              ),
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '¡Contáctanos!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text('Teléfono: ${contactInfo.phoneNumber}'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(
                          'Correo Electrónico: ${contactInfo.emailAddress}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu correo Electronico';
                  }
                  // Puedes agregar más validaciones de formato de correo aquí
                  return null;
                },
              ),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Mensaje'),
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa un mensaje';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
