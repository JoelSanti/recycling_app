import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:recycling_app/constants/app_constants.dart';
import 'package:recycling_app/utils/data/waste_info.dart';
import 'package:recycling_app/views/screens/home/widget/LabelInfoDialog.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  List<ImageLabel>? _imageLabels;

  void _pickImage(ImageSource source) async {
    final pickedImageFile = await _picker.pickImage(
      source: source,
    );

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      _processImage(_pickedImage!);
    } else {
      print('No image selected.');
    }
  }

  void _processImage(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final imageLabelerOptions = ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: imageLabelerOptions);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    print('\n \nETIQUETAS OBTENIDAS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++: '
        '\n \n ${labels.map((label) => 'Label: ${label.label}, ${label.confidence} \n').join(', ')} \n \n');

    // Sort the labels by confidence in descending order and take the first one
    labels.sort((a, b) => b.confidence.compareTo(a.confidence));
    ImageLabel highestConfidenceLabel = labels.first;

    setState(() {
      _imageLabels = [highestConfidenceLabel]; // Store only the label with the highest confidence
    });

    imageLabeler.close();

    // Show the dialog once the labels have been obtained
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LabelInfoDialog(imageLabels: _imageLabels);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> labelWidgets = [];

    if (_imageLabels != null && _imageLabels!.isNotEmpty) {
      var label = _imageLabels!.first;
      var info = wasteInfo[label.label.toLowerCase()];
      if (info != null) {
        labelWidgets.add(
          Column(
            children: <Widget>[
              Text(
                '${info['spanish']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Tipo: ${info['type']} \nDescripción: ${info['description']}'),
            ],
          ),
        );
      }
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Color(KGreen.value).withOpacity(0.5),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: _pickedImage != null
                  ? Image.file(
                      _pickedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Center(
                      child: Text("Por favor suba una imagen"),
                    ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color(kLightBlue.value),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text(
                            "Completar la acción usando..",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                          ],
                          content: Container(
                            height: 120,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text(
                                    "Cámara",
                                  ),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text(
                                    "Galería",
                                  ),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  'Agregar Imagen',
                ),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Color(kLight.value)),
                )),
          ),
        ),
        // Agregar un widget para mostrar las etiquetas
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LabelInfoDialog(imageLabels: _imageLabels);
                  },
                );
              },
              child: Text('Mostrar información de los residuos'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
