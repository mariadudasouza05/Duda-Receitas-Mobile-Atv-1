import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int categoriaSelecionada = 0;
  int paginaSelecionada = 0;

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _termoPesquisado;

  final categorias = [
    'Todas',
    'Café da manhã',
    'Almoço',
    'Jantar',
    'Sobremesas',
    'Lanches',
  ];

  final receitas = [
    ['🍫', 'Brownie de chocolate', '45 min', 'Médio'],
    ['🥗', 'Salada de frango', '20 min', 'Fácil'],
    ['🍓', 'Vitamina de morango', '10 min', 'Fácil'],
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executarPesquisa() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _termoPesquisado = _searchController.text.trim();
      });
    }
  }

  void _limparPesquisa() {
    setState(() {
      _searchController.clear();
      _termoPesquisado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7F0),
        title: const Text(
          'Receitas da Duda',
          style: TextStyle(
            color: Color(0xFF496747),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B32),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'O que vamos cozinhar hoje?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // FORMULÁRIO COM CAMPO ROTULADO E VALIDAÇÃO
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (_) => _executarPesquisa(),
                validator: (value) {
                  // Recusa entradas vazias ou apenas com espaços
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome da receita para pesquisar (ex: Bolo, Salada).';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Pesquisar receita',
                  hintText: 'Digite o nome da receita...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'Buscar',
                    onPressed: _executarPesquisa,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
              ),
            ),

            if (_termoPesquisado != null) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE8D6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Exibindo resultados para: "$_termoPesquisado"',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263B32),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      tooltip: 'Limpar e nova consulta',
                      onPressed: _limparPesquisa,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            const Text(
              'Categorias',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 42,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(categorias[index]),
                      selected: categoriaSelecionada == index,
                      selectedColor: const Color(0xFFDCE8D6),
                      onSelected: (selecionada) {
                        setState(() {
                          categoriaSelecionada = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Receita em destaque',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF496747),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🍝',
                    style: TextStyle(fontSize: 42),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Macarrão cremoso com frango',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Uma receita prática e deliciosa para o dia a dia!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '30 min',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 15),
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Fácil',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Receitas populares',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B32),
              ),
            ),
            const SizedBox(height: 12),

            ...receitas.map((receita) {
              return Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Text(
                    receita[0],
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    receita[1],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('${receita[2]} • ${receita[3]}'),
                  trailing: const Icon(
                    Icons.favorite_border,
                    color: Color(0xFF496747),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaSelecionada,
        onDestinationSelected: (index) {
          setState(() {
            paginaSelecionada = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Receitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}