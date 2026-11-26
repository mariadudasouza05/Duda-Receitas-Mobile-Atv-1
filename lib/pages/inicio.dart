import 'package:flutter/material.dart';

import '../models/receita.dart';
import '../services/receita_service.dart';
import 'detalhes_receita.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final ReceitaService _receitaService = ReceitaService();

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Receita> receitas = [];
  List<Receita> favoritos = [];

  String? _termoPesquisado;
  String? erro;

  bool carregando = false;
  int paginaSelecionada = 0;

  static const Color verde = Color(0xFF496747);
  static const Color fundo = Color(0xFFFAF7F0);
  static const Color verdeClaro = Color(0xFFDCE8D6);
  static const Color textoEscuro = Color(0xFF263B32);

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  void _atualizarFavorito(Receita receita, bool salvar) {
    setState(() {
      if (salvar) {
        final jaExiste = favoritos.any((item) => item.id == receita.id);
        if (!jaExiste) {
          favoritos.add(receita);
        }
      } else {
        favoritos.removeWhere((item) => item.id == receita.id);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarReceitas() async {
    if (carregando) return;

    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await _receitaService.buscarReceitas();

      if (!mounted) return;

      setState(() {
        receitas = resultado;
        carregando = false;
      });
    } catch (e) {
      debugPrint('=== ERRO AO CARREGAR RECEITAS: $e ===');

      if (!mounted) return;

      setState(() {
        erro = 'Não foi possível carregar as receitas.';
        carregando = false;
      });
    }
  }

  Future<void> _executarPesquisa() async {
    if (carregando) return;

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
      final resultado = await _receitaService.pesquisarReceitas(termo);

      if (!mounted) return;

      setState(() {
        receitas = resultado;
        carregando = false;
      });
    } catch (e) {
      debugPrint('=== ERRO AO PESQUISAR RECEITAS: $e ===');

      if (!mounted) return;

      setState(() {
        erro = 'Não foi possível realizar a pesquisa.';
        carregando = false;
      });
    }
  }

  void _limparPesquisa() {
    if (carregando) return;

    _searchController.clear();

    setState(() {
      _termoPesquisado = null;
    });

    _carregarReceitas();
  }

  String _tempoTotal(Receita receita) {
    if (receita.tempoPreparo == null && receita.tempoCozimento == null) {
      return 'Tempo não informado';
    }

    final preparo = receita.tempoPreparo ?? 0;
    final cozimento = receita.tempoCozimento ?? 0;
    final total = preparo + cozimento;

    if (total <= 0) {
      return 'Tempo não informado';
    }

    return '$total min';
  }

  Widget _imagemReceita(
      String? imagem, {
        double width = 100,
        double height = 100,
      }) {
    return Container(
      width: width,
      height: height,
      color: verdeClaro,
      child: imagem != null && imagem.isNotEmpty
          ? Image.network(
        imagem,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.restaurant,
            size: 40,
            color: verde,
          );
        },
      )
          : const Icon(
        Icons.restaurant,
        size: 40,
        color: verde,
      ),
    );
  }

  Widget _cardReceita(Receita receita) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetalhesReceita(
                  receita: receita,
                  favoritaInicial: favoritos.any(
                        (item) => item.id == receita.id,
                  ),
                  onFavoritoAlterado: (salvar) {
                    _atualizarFavorito(receita, salvar);
                  },
                );
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _imagemReceita(
                  receita.imagem,
                  width: 90,
                  height: 100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receita.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textoEscuro,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: verde,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            _tempoTotal(receita),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 15,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          receita.avaliacao != null
                              ? '${receita.avaliacao!.toStringAsFixed(1)} / 5'
                              : 'Sem avaliação',
                          style: const TextStyle(
                            fontSize: 12,
                            color: verde,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: verde,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _conteudoReceitas() {
    if (carregando) {
      return const Padding(
        padding: EdgeInsets.all(35),
        child: Column(
          children: [
            CircularProgressIndicator(color: verde),
            SizedBox(height: 14),
            Text(
              'Carregando receitas...',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }

    if (erro != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 45,
          horizontal: 20,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.wifi_off,
              size: 55,
              color: verde,
            ),
            const SizedBox(height: 18),
            Text(
              erro!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textoEscuro,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Verifique sua conexão e tente novamente.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _termoPesquisado == null
                  ? _carregarReceitas
                  : _executarPesquisa,
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (receitas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 20,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.search_off,
              size: 55,
              color: verde,
            ),
            const SizedBox(height: 15),
            const Text(
              'Nenhum resultado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textoEscuro,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Não encontramos receitas para esse nome. Tente outro termo.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _limparPesquisa,
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ver todas as receitas'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: receitas.map((receita) {
        return _cardReceita(receita);
      }).toList(),
    );
  }

  Widget _telaExplorar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Receitas',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textoEscuro,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Pesquise uma receita pelo nome.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
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
                hintText: 'Buscar pelo nome',
                prefixIcon: const Icon(
                  Icons.search,
                  color: verde,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: verde),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: carregando ? null : _executarPesquisa,
              style: ElevatedButton.styleFrom(
                backgroundColor: verde,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Buscar receitas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            _termoPesquisado == null
                ? 'Receitas disponíveis'
                : 'Resultados para "$_termoPesquisado"',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textoEscuro,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _termoPesquisado == null
                ? 'Selecione uma receita para ver o preparo.'
                : 'Receitas encontradas na pesquisa.',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          _conteudoReceitas(),
          if (_termoPesquisado != null &&
              !carregando &&
              erro == null &&
              receitas.isNotEmpty) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _limparPesquisa,
              style: OutlinedButton.styleFrom(
                foregroundColor: verde,
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: verde),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text('Limpar pesquisa'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _telaFavoritos() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favoritos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textoEscuro,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Receitas salvas nesta sessão.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          if (favoritos.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        color: verdeClaro,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 45,
                        color: textoEscuro,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Nenhum favorito',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textoEscuro,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Marque uma receita como favorita para encontrá-la aqui.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            paginaSelecionada = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text(
                          'Explorar receitas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: favoritos.length,
                itemBuilder: (context, index) {
                  final receita = favoritos[index];
                  return _cardReceita(receita);
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        title: const Text(
          'Duda Receitas',
          style: TextStyle(
            color: verde,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: paginaSelecionada == 0 ? _telaExplorar() : _telaFavoritos(),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: verdeClaro,
        selectedIndex: paginaSelecionada,
        onDestinationSelected: (index) {
          setState(() {
            paginaSelecionada = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}