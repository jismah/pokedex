import 'package:flutter/material.dart';
import 'package:pokedex/Models/pokemon.dart';

class EvolucionesUI extends StatefulWidget {
  final Pokemon pokemon;

  const EvolucionesUI({super.key, required this.pokemon});

  @override
  State<EvolucionesUI> createState() => _EvolucionesUIState();
}

class _EvolucionesUIState extends State<EvolucionesUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Evoluciones",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        backgroundColor: Colors.red,
      ),
      body: const SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: Text("Evoluciones"),
          )
        ],
      )),
    );
  }
}
