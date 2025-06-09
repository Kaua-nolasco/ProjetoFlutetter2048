import 'dart:math';
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
  static const int gridSize = 4;
  late List<List<int>> grid;
  int movimentos = 0;
  String status = '';

  @override
  void initState() {
    super.initState();
    _iniciarJogo();
  }

  void _iniciarJogo() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    _adicionarNumero();
    _adicionarNumero();
    movimentos = 0;
    status = '';
    setState(() {});
  }

  void _adicionarNumero() {
    final empty = <Point<int>>[];
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (grid[y][x] == 0) {
          empty.add(Point(x, y));
        }
      }
    }

    if (empty.isNotEmpty) {
      final pos = empty[Random().nextInt(empty.length)];
      grid[pos.y][pos.x] = Random().nextInt(10) < 9 ? 2 : 4;
    }
  }

  void _mover(String direcao) {
    setState(() {
      List<List<int>> novaGrid = List.generate(gridSize, (y) => List.from(grid[y]));
      bool moved = false;

      for (int i = 0; i < (direcao == 'esquerda' || direcao == 'direita' ? gridSize : 1); i++) {
        List<int> linha = [];
        for (int j = 0; j < gridSize; j++) {
          int valor;
          if (direcao == 'esquerda' || direcao == 'direita') {
            valor = grid[i][j];
          } else {
            valor = grid[j][i];
          }
          linha.add(valor);
        }

        if (direcao == 'direita' || direcao == 'baixo') {
          linha = linha.reversed.toList();
        }

        List<int> novaLinha = _compactarLinha(linha);

        if (direcao == 'direita' || direcao == 'baixo') {
          novaLinha = novaLinha.reversed.toList();
        }

        for (int j = 0; j < gridSize; j++) {
          int valorAntes = direcao == 'esquerda' || direcao == 'direita' ? grid[i][j] : grid[j][i];
          int novoValor = novaLinha[j];
          if (valorAntes != novoValor) moved = true;
          if (direcao == 'esquerda' || direcao == 'direita') {
            novaGrid[i][j] = novoValor;
          } else {
            novaGrid[j][i] = novoValor;
          }
        }
      }

      if (moved) {
        grid = novaGrid;
        _adicionarNumero();
        movimentos++;
        _verificarStatus();
      }
    });
  }

  List<int> _compactarLinha(List<int> linha) {
    linha = linha.where((x) => x != 0).toList();
    for (int i = 0; i < linha.length - 1; i++) {
      if (linha[i] == linha[i + 1]) {
        linha[i] *= 2;
        linha[i + 1] = 0;
      }
    }
    return linha.where((x) => x != 0).toList() + List.filled(gridSize - linha.where((x) => x != 0).length, 0);
  }

  void _verificarStatus() {
    for (var linha in grid) {
      if (linha.contains(2048)) {
        status = 'Você venceu!';
        return;
      }
    }

    bool temMovimento = false;

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (grid[y][x] == 0) {
          temMovimento = true;
        } else {
          if (x < gridSize - 1 && grid[y][x] == grid[y][x + 1]) temMovimento = true;
          if (y < gridSize - 1 && grid[y][x] == grid[y + 1][x]) temMovimento = true;
        }
      }
    }

    if (!temMovimento) {
      status = 'Fim de jogo!';
    }
  }

  Widget _buildGrid() {
    return SizedBox(
      height: 300,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: gridSize * gridSize,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridSize),
        itemBuilder: (context, index) {
          int x = index % gridSize;
          int y = index ~/ gridSize;
          int value = grid[y][x];
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: value == 0 ? Colors.grey[300] : Colors.orange[100 + (value.bitLength * 20)],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                value == 0 ? '' : '$value',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControles() {
    return Column(
      children: [
        IconButton(icon: const Icon(Icons.arrow_upward), onPressed: () => _mover('cima')),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => _mover('esquerda')),
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => _mover('direita')),
          ],
        ),
        IconButton(icon: const Icon(Icons.arrow_downward), onPressed: () => _mover('baixo')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo 2048 - Fácil'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _iniciarJogo, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Movimentos: $movimentos', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildControles(),
            const SizedBox(height: 20),
            _buildGrid(),
          ],
        ),
      ),
    );
  }
}
