import 'package:flutter/material.dart';
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.image,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  String? image; // image can now be null
  bool isExpanded;
}

class AwarenessPage extends StatefulWidget {
  const AwarenessPage({Key? key}) : super(key: key);

  @override
  _AwarenessPageState createState() => _AwarenessPageState();
}

class _AwarenessPageState extends State<AwarenessPage> {
  List<Item> _data = generateItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual de sensibilización'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0), // Add padding here
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ExpansionTile(
                leading: _data[index].image != null ? Image.asset(_data[index].image!) : null,
                title: Text(_data[index].headerValue),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(_data[index].expandedValue),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<Item> generateItems() {
  return [
    Item(
      headerValue: '¿Por qué es importante el reciclaje?',
      expandedValue: 'El reciclaje es importante porque permite reducir la cantidad de residuos que se envían a los vertederos y las incineradoras, conservar los recursos naturales como el agua, los minerales y la madera, y prevenir la contaminación al reducir la necesidad de recolectar nuevos materiales crudos.',
      image: 'assets/images/ms1.jpg',
    ),
    Item(
      headerValue: '¿Cómo puedo empezar a reciclar?',
      expandedValue: 'Puedes empezar a reciclar separando tus residuos en diferentes contenedores: papel y cartón, plástico, vidrio, y residuos orgánicos. Asegúrate de limpiar los materiales reciclables antes de desecharlos para evitar la contaminación.',
      image: 'assets/images/ms2.jpg',    ),
    Item(
      headerValue: '¿Qué materiales son reciclables?',
      expandedValue: 'Los materiales comúnmente reciclables incluyen papel y cartón, plástico, vidrio, metal y materiales orgánicos. Sin embargo, no todos los tipos de estos materiales son reciclables. Por ejemplo, algunos tipos de plástico no son reciclables. Siempre verifica las normas de reciclaje locales.',
      image: 'assets/images/ms3.jpg',    ),
    Item(
      headerValue: '¿Qué es el reciclaje de compost?',
      expandedValue: 'El compostaje es un tipo de reciclaje que transforma los residuos orgánicos, como restos de comida y residuos de jardín, en compost, un fertilizante rico en nutrientes. El compostaje en casa puede ayudar a reducir la cantidad de residuos orgánicos que se envían a los vertederos y proporcionar un fertilizante gratuito para tu jardín.',
      image: 'assets/images/ms4.jpg',    ),
    Item(
      headerValue: '¿Cómo puedo reducir mi producción de residuos?',
      expandedValue: 'Además de reciclar, puedes reducir tu producción de residuos comprando solo lo que necesitas, eligiendo productos con menos embalaje, reutilizando artículos en lugar de desecharlos, y compostando residuos orgánicos. Recuerda, la mejor manera de manejar los residuos es no producirlos en primer lugar.',
      image: 'assets/images/ms5.jpg',    ),
    Item(
      headerValue: '¿Qué es la economía circular?',
      expandedValue: 'La economía circular es un modelo económico que tiene como objetivo reducir el desperdicio y promover la reutilización, el reciclaje y la renovación de los recursos. En lugar de seguir un modelo lineal de "extraer, fabricar, desechar", la economía circular busca cerrar el ciclo de vida de los productos y materiales para minimizar la generación de residuos y maximizar el valor de los recursos.',
      image: 'assets/images/ms6.jpg',    ),
    Item(
      headerValue: '¿Qué es la huella de carbono?',
      expandedValue: 'La huella de carbono es una medida de la cantidad de gases de efecto invernadero, como el dióxido de carbono, que se emiten a la atmósfera como resultado de las actividades humanas. Al reciclar, reducir el consumo de energía y elegir productos sostenibles, puedes ayudar a reducir tu huella de carbono y mitigar el cambio climático.',
      image: 'assets/images/ms7.jpg',    ),
    Item(
      headerValue: '¿Cómo puedo ser más sostenible en mi vida diaria?',
      expandedValue: 'Para ser más sostenible en tu vida diaria, puedes reducir tu consumo de energía, agua y recursos naturales, reciclar y reutilizar materiales siempre que sea posible, elegir productos sostenibles y de comercio justo, y apoyar a empresas y organizaciones que promueven prácticas sostenibles.',
      image: 'assets/images/ms8.jpg',    ),
    Item(
      headerValue: '¿Cómo puedo apoyar la sostenibilidad en mi comunidad?',
      expandedValue: 'Puedes apoyar la sostenibilidad en tu comunidad participando en programas de reciclaje locales, comprando productos locales y sostenibles, apoyando a empresas y organizaciones que promueven prácticas sostenibles, y educando a otros sobre la importancia de la sostenibilidad y cómo pueden contribuir a un futuro más sostenible.',
      image: 'assets/images/ms9.jpg',    ),
    Item(
      headerValue: '¿Qué es la responsabilidad extendida del productor?',
      expandedValue: 'La responsabilidad extendida del productor es un principio ambiental que establece que los fabricantes y los productores de bienes son responsables de la gestión adecuada de los productos al final de su vida útil. Esto significa que los productores deben asumir la responsabilidad de la recolección, el reciclaje y la eliminación segura de los productos que fabrican, en lugar de dejar esta responsabilidad en manos de los consumidores o las autoridades locales.',
      image: 'assets/images/ms10.jpg',    )

  ];
}