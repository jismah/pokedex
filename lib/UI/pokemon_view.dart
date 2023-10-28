import 'package:flutter/material.dart';

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pokemon View",
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(child: Text("Pokemon View")),
    );
  }
}
