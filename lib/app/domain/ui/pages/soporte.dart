import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class SoportePage extends StatelessWidget {
  SoportePage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _launchPhone(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _launchEmail(String emailAddress) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'Could not launch $emailAddress';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                    onTap: () => _launchPhone(contactInfo.phoneNumber),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text('Correo Electrónico: ${contactInfo.emailAddress}'),
                    onTap: () => _launchEmail(contactInfo.emailAddress),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '¿Problemas o preguntas? ¡Háganoslo saber!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Formulario para enviar problemas o preguntas
            Form(
              key: _formKey, // Asignar clave global al formulario
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su nombre.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese su correo electrónico.';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor, ingrese un correo electrónico válido.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Mensaje'),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese un mensaje.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Lógica para enviar el formulario
                        final String name = _nameController.text;
                        final String email = _emailController.text;
                        final String message = _messageController.text;

                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: contactInfo.emailAddress,
                          queryParameters: {
                            'subject': 'Contacto desde la aplicación',
                            'body': 'Nombre: $name\nCorreo: $email\n\nMensaje:\n$message',
                          }
                        );
                        launch(emailUri.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Formulario enviado correctamente.')),
                        );
                      }
                    },
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
