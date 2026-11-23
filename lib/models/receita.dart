class Receita {
  final int id;
  final String nome;
  final List<String> ingredientes;
  final List<String> instrucoes;
  final String? imagem;
  final int? tempoPreparo;
  final int? tempoCozimento;
  final int? porcoes;
  final double? avaliacao;
  final List<String> tipoRefeicao;

  Receita({
    required this.id,
    required this.nome,
    required this.ingredientes,
    required this.instrucoes,
    this.imagem,
    this.tempoPreparo,
    this.tempoCozimento,
    this.porcoes,
    this.avaliacao,
    required this.tipoRefeicao,
  });

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : 0,

      nome: json['name'] is String
          ? json['name']
          : 'Receita sem nome',

      ingredientes: _converterLista(json['ingredients']),

      instrucoes: _converterLista(json['instructions']),

      imagem: json['image'] is String
          ? json['image']
          : null,

      tempoPreparo: json['prepTimeMinutes'] is num
          ? (json['prepTimeMinutes'] as num).toInt()
          : null,

      tempoCozimento: json['cookTimeMinutes'] is num
          ? (json['cookTimeMinutes'] as num).toInt()
          : null,

      porcoes: json['servings'] is num
          ? (json['servings'] as num).toInt()
          : null,

      avaliacao: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : null,

      tipoRefeicao: _converterLista(json['mealType']),
    );
  }

  static List<String> _converterLista(dynamic valor) {
    if (valor is List) {
      return valor
          .whereType<String>()
          .toList();
    }

    return [];
  }
}