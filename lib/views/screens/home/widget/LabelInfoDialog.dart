import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:recycling_app/constants/app_constants.dart';
import 'package:recycling_app/models/response/auth/auth_model.dart';
import 'package:recycling_app/utils/data/waste_info.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';



Future<bool> sendScanData(BuildContext context, String? wasteTypeDescription) async {
  print('Enviando datos de escaneo...');
  final url = 'https://servidor-recycling-s4lb.onrender.com/api/scans';
  final authModel = Provider.of<AuthModel>(context, listen: false);
  print('Token:+++++++++++++++ ${authModel.token}');
  print('User ID: ++++++++++++++${authModel.userId}');

  final Map<String, String> wasteTypeMapping = {
    'Residuos Aprovechables': 'residuos_aprovechables',
    'Residuos Orgánicos Aprovechables': 'residuos_organicos_aprovechables',
    'Residuos No Aprovechables': 'residuos_no_aprovechables',
  };
  // Convertir la descripción del tipo de residuo a un valor válido
  final wasteType = wasteTypeMapping[wasteTypeDescription] ?? 'residuos_no_aprovechables';
  print('Tipo de residuo: $wasteType');
  print('Fecha de escaneo: ${DateTime.now().toIso8601String()}');

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Authorization': 'JWT ${authModel.token}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'scanDate': DateTime.now().toIso8601String(),// Format the date as "yyyy-MM-dd"
      'resident': authModel.userId!, // Usa el ID del usuario
      'wasteType': wasteType,
    }),
  );

  print('Response +++++++++++++++++++++++++++++++++++++++++++++++: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Datos enviados con éxito');
    return true;
  } else {
    throw Exception('Error al enviar los datos');
  }
}

class LabelInfoDialog extends StatelessWidget {
  final List<ImageLabel>? imageLabels;

  // Mapa de descripciones
  final Map<String, String> descriptions = {
    'Residuos Aprovechables':
        'Son aquellos residuos que pueden ser reciclados o reutilizados, como papel y cartón (periódicos, revistas, cajas), plásticos (botellas, envases, bolsas), vidrio (botellas, frascos), metales (latas de aluminio, chatarra), textiles (ropa, telas) y madera (paletas, muebles viejos). Estos materiales se pueden procesar para crear nuevos productos, reduciendo la necesidad de materias primas vírgenes y disminuyendo el impacto ambiental.',
    'Residuos Orgánicos Aprovechables':
        'Estos residuos son biodegradables y se pueden compostar para crear abono orgánico, mejorando la calidad del suelo y reduciendo la necesidad de fertilizantes químicos. Incluyen restos de alimentos (cáscaras de frutas y verduras, restos de comidas, posos de café), residuos de jardinería (hojas, césped cortado, ramas pequeñas) y residuos de poda (restos de poda de árboles y arbustos).',
    'Residuos No Aprovechables':
        'Son aquellos residuos que no pueden ser reciclados ni compostados debido a su composición o contaminación, y generalmente se destinan a rellenos sanitarios o incineración. Incluyen productos como pañales desechables, papel higiénico usado, toallas sanitarias, colillas de cigarrillos, envases contaminados con sustancias peligrosas, y algunos tipos de plásticos no reciclables.'
  };

  LabelInfoDialog({Key? key, this.imageLabels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var label = imageLabels != null && imageLabels!.isNotEmpty
        ? imageLabels!.first
        : null;
    var info = label != null ? wasteInfo[label.label.toLowerCase()] : null;
    var type = info != null ? info['type'] : null;

    Color backgroundColor;
    switch (type) {
      case 'Residuos Aprovechables':
        backgroundColor = Colors.white;
        break;
      case 'Residuos Orgánicos Aprovechables':
        backgroundColor = Colors.green[100] ??
            Colors
                .green; // Default to Colors.green if Colors.green[100] is null
        break;
      case 'Residuos No Aprovechables':
        backgroundColor = Colors.red[100] ??
            Colors.red; // Default to Colors.red if Colors.red[100] is null
        break;
      default:
        backgroundColor = Colors.red[100] ?? Colors.red;
    }

    return AlertDialog(
      backgroundColor: backgroundColor,
      title: const Text(
        'TIPO DE ELEMENTOS ENCONTRADOS',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: imageLabels != null && imageLabels!.isNotEmpty
              ? imageLabels!.map((label) {
                  var info = wasteInfo[label.label.toLowerCase()];
                  if (info != null) {
                    return Column(
                      children: <Widget>[
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '${info['type']}\n\n',
                                style: TextStyle(color: Color(kDarkBlue.value)),
                              ),
                              TextSpan(
                                text: 'Descripción: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(kDarkBlue.value)),
                              ),
                              TextSpan(
                                text: '${descriptions[info['type']]}',
                                style: TextStyle(color: Color(kDarkBlue.value)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Residuos No Aprovechables\n\n',
                                style: TextStyle(color: Color(kDarkBlue.value)),
                              ),
                              TextSpan(
                                text: 'Descripción: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(kDarkBlue.value)),
                              ),
                              TextSpan(
                                text:
                                    'Son aquellos residuos que no pueden ser reciclados ni compostados debido a su composición o contaminación, y generalmente se destinan a rellenos sanitarios o incineración. Incluyen productos como pañales desechables, papel higiénico usado, toallas sanitarias, colillas de cigarrillos, envases contaminados con sustancias peligrosas, y algunos tipos de plásticos no reciclables',
                                style: TextStyle(color: Color(kDarkBlue.value)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }).toList()
              : [const Text('Ingrese una imagen para obtener información')],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Guardar Resultado'),
          onPressed: () async {
            print('El tipo de residuo es: $type');
            bool success = await sendScanData(context, type);
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(success ? 'Éxito' : 'Error'),
                  content: Text(success ? 'Datos guardados con éxito.' : 'Hubo un error al guardar los datos.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
