import 'package:flutter/material.dart';

void main() {
  runApp(const Jogo2048App());
}

class Jogo2048App extends StatelessWidget {
  const Jogo2048App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo 2048',
      home: const Jogo2048HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Jogo2048HomePage extends StatefulWidget {
  const Jogo2048HomePage({super.key});

  @override
  State<Jogo2048HomePage> createState() => _Jogo2048HomePageState();
}

class _Jogo2048HomePageState extends State<Jogo2048HomePage> {
  int gridSize = 4;
  int movimentos = 0;
  String status = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo 2048'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Movimentos: $movimentos', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _mudarNivel(4), child: const Text('Nível Fácil')),
                ElevatedButton(onPressed: () => _mudarNivel(5), child: const Text('Nível Médio')),
                ElevatedButton(onPressed: () => _mudarNivel(6), child: const Text('Nível Difícil')),
              ],
            ),
            const SizedBox(height: 20),
            _buildGrid(),
            const SizedBox(height: 20),
            _buildControles(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: gridSize * gridSize,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(2),
            color: Colors.grey[300],
            child: const Center(child: Text('1')), // apenas exemplo, pode ser dinâmico
          );
        },
      ),
    );
  }

  Widget _buildControles() {
    return Column(
      children: [
        IconButton(icon: const Icon(Icons.arrow_upward), onPressed: _mover),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: _mover),
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _mover),
          ],
        ),
        IconButton(icon: const Icon(Icons.arrow_downward), onPressed: _mover),
      ],
    );
  }

  void _mudarNivel(int tamanho) {
    setState(() {
      gridSize = tamanho;
      movimentos = 0;
      status = '';
    });
  }

  void _mover() {
    setState(() {
      movimentos++;
    });
  }
}