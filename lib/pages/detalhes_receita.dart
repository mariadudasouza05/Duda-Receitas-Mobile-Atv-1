import 'package:flutter/material.dart';
import '../models/receita.dart';

class DetalhesReceita extends StatefulWidget {
  final Receita receita;

  const DetalhesReceita({
    super.key,
    required this.receita,
  });

  @override
  State<DetalhesReceita> createState() => _DetalhesReceitaState();
}

class _DetalhesReceitaState extends State<DetalhesReceita> {
  bool favorita = false;

  static const Color verde = Color(0xFF496747);
  static const Color fundo = Color(0xFFFAF7F0);
  static const Color verdeClaro = Color(0xFFDCE8D6);
  static const Color textoEscuro = Color(0xFF263B32);

  int get tempoTotal {
    return (widget.receita.tempoPreparo ?? 0) +
        (widget.receita.tempoCozimento ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final receita = widget.receita;

    return Scaffold(
      backgroundColor: fundo,

      appBar: AppBar(
        backgroundColor: fundo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: verde,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Receita',
          style: TextStyle(
            color: textoEscuro,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                favorita = !favorita;
              });
            },
            icon: Icon(
              favorita
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favorita ? Colors.red : verde,
              size: 28,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Imagem da receita
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 220,
                color: verdeClaro,
                child: receita.imagem != null &&
                    receita.imagem!.isNotEmpty
                    ? Image.network(
                  receita.imagem!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.restaurant,
                      size: 65,
                      color: verde,
                    );
                  },
                )
                    : const Icon(
                  Icons.restaurant,
                  size: 65,
                  color: verde,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nome da receita
            Text(
              receita.nome,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: textoEscuro,
              ),
            ),

            const SizedBox(height: 8),

            // Tipo de refeição e avaliação
            Row(
              children: [
                Expanded(
                  child: Text(
                    receita.tipoRefeicao.isNotEmpty
                        ? receita.tipoRefeicao.join(' • ')
                        : 'Receita',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 19,
                ),
                const SizedBox(width: 4),
                Text(
                  receita.avaliacao != null
                      ? '${receita.avaliacao!.toStringAsFixed(1)} / 5'
                      : 'Sem avaliação',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textoEscuro,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Informações da receita
            Row(
              children: [
                Expanded(
                  child: _informacao(
                    Icons.access_time,
                    tempoTotal > 0
                        ? '$tempoTotal min'
                        : '--',
                    'tempo total',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _informacao(
                    Icons.people_outline,
                    receita.porcoes != null
                        ? '${receita.porcoes}'
                        : '--',
                    'porções',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _informacao(
                    favorita
                        ? Icons.favorite
                        : Icons.favorite_border,
                    favorita ? 'Salva' : 'Salvar',
                    'nos favoritos',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Ingredientes
            const Text(
              'Ingredientes',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: textoEscuro,
              ),
            ),

            const SizedBox(height: 12),

            if (receita.ingredientes.isEmpty)
              const Text(
                'Ingredientes não disponíveis.',
                style: TextStyle(color: Colors.black54),
              )
            else
              ...receita.ingredientes.map((ingrediente) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 18,
                          color: verde,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ingrediente,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 25),

            // Modo de preparo
            const Text(
              'Modo de preparo',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: textoEscuro,
              ),
            ),

            const SizedBox(height: 15),

            if (receita.instrucoes.isEmpty)
              const Text(
                'Modo de preparo não disponível.',
                style: TextStyle(color: Colors.black54),
              )
            else
              ...receita.instrucoes.asMap().entries.map((entrada) {
                final numero = entrada.key + 1;
                final instrucao = entrada.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: verde,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$numero',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            instrucao,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: textoEscuro,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _informacao(
      IconData icone,
      String valor,
      String descricao,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: verdeClaro.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(
            icone,
            color: verde,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textoEscuro,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}