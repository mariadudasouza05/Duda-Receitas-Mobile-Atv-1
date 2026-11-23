import 'package:flutter/material.dart';

import '../models/receita.dart';
import '../services/receita_service.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int categoriaSelecionada = 0;
  int paginaSelecionada = 0;

  final TextEditingController _searchController =
  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ReceitaService _receitaService = ReceitaService();

  List<Receita> receitas = [];

  String? _termoPesquisado;
  String? erro;

  bool carregando = true;

  final categorias = [
    'Todas',
    'Café da manhã',
    'Almoço',
    'Jantar',
    'Sobremesas',
    'Lanches',
  ];

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarReceitas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado =
      await _receitaService.buscarReceitas();

      if (!mounted) return;

      setState(() {
        receitas = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = 'Não foi possível carregar as receitas.';
        carregando = false;
      });
    }
  }

  Future<void> _executarPesquisa() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final termo = _searchController.text.trim();

    setState(() {
      _termoPesquisado = termo;
      carregando = true;
      erro = null;
    });

    try {
      final resultado =
      await _receitaService.pesquisarReceitas(termo);

      if (!mounted) return;

      setState(() {
        receitas = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = 'Não foi possível realizar a pesquisa.';
        carregando = false;
      });
    }
  }

  void _limparPesquisa() {
    _searchController.clear();

    setState(() {
      _termoPesquisado = null;
    });

    _carregarReceitas();
  }

  String _tempoTotal(Receita receita) {
    final preparo = receita.tempoPreparo ?? 0;
    final cozimento = receita.tempoCozimento ?? 0;

    final total = preparo + cozimento;

    if (total == 0) {
      return 'Tempo não informado';
    }

    return '$total min';
  }

  Widget _imagemReceita(String? imagem, {double? height}) {
    return Container(
      height: height ?? 110,
      width: height == null ? 110 : double.infinity,
      color: const Color(0xFFDCE8D6),
      child: imagem != null && imagem.isNotEmpty
          ? Image.network(
        imagem,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.restaurant,
            size: 45,
            color: Color(0xFF496747),
          );
        },
      )
          : const Icon(
        Icons.restaurant,
        size: 45,
        color: Color(0xFF496747),
      ),
    );
  }

  Widget _cardReceita(Receita receita) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _imagemReceita(receita.imagem),
        ),
        title: Text(
          receita.nome,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF263B32),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Color(0xFF496747),
                  ),
                  const SizedBox(width: 5),
                  Text(_tempoTotal(receita)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    receita.avaliacao != null
                        ? receita.avaliacao!.toStringAsFixed(1)
                        : 'Sem avaliação',
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.favorite_border,
          color: Color(0xFF496747),
        ),
      ),
    );
  }

  Widget _conteudoReceitas() {
    if (carregando) {
      return const Padding(
        padding: EdgeInsets.all(35),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF496747),
          ),
        ),
      );
    }

    if (erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(
                Icons.wifi_off,
                size: 45,
                color: Color(0xFF496747),
              ),
              const SizedBox(height: 12),
              Text(
                erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _termoPesquisado == null
                    ? _carregarReceitas
                    : _executarPesquisa,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF496747),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (receitas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 45,
                color: Color(0xFF496747),
              ),
              SizedBox(height: 12),
              Text(
                'Nenhuma receita encontrada.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: receitas.map((receita) {
        return _cardReceita(receita);
      }).toList(),
    );
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

            Form(
              key: _formKey,
              child: TextFormField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (_) => _executarPesquisa(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite o nome de uma receita.';
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
                    onPressed: carregando
                        ? null
                        : _executarPesquisa,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),

            if (_termoPesquisado != null) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE8D6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Resultados para: "$_termoPesquisado"',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263B32),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Limpar pesquisa',
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

            if (!carregando && erro == null && receitas.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF496747),
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imagemReceita(
                      receitas.first.imagem,
                      height: 170,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receitas.first.nome,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _tempoTotal(receitas.first),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                receitas.first.avaliacao != null
                                    ? receitas.first.avaliacao!
                                    .toStringAsFixed(1)
                                    : 'Sem avaliação',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else if (carregando)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF496747),
                ),
              )
            else
              const Text(
                'Nenhuma receita em destaque disponível.',
              ),

            const SizedBox(height: 25),

            Text(
              _termoPesquisado == null
                  ? 'Receitas populares'
                  : 'Resultados da pesquisa',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263B32),
              ),
            ),

            const SizedBox(height: 12),

            _conteudoReceitas(),
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