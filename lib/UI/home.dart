import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 70,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 30.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: 'Buscar...',
            ),
          ),
        ),
/*         Expanded(
          child: ListView(
            children: const <Widget>[
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Album'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Album'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
              ),
            ],
          ),
        ) */
      ],
    );
  }
}
