import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receita.dart';

class ReceitaService {
  static const String baseUrl = 'https://dummyjson.com/recipes';

  Future<List<Receita>> buscarReceitas() async {
    final url = Uri.parse(baseUrl);

    final resposta = await http.get(url).timeout(
      const Duration(seconds: 15),
    );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados is! Map<String, dynamic> ||
          dados['recipes'] is! List) {
        throw Exception('Formato de resposta inválido.');
      }

      final List receitasJson = dados['recipes'];

      return receitasJson
          .whereType<Map<String, dynamic>>()
          .map((json) => Receita.fromJson(json))
          .toList();
    } else {
      throw Exception('Erro ao buscar receitas.');
    }
  }

  Future<List<Receita>> pesquisarReceitas(String nome) async {
    final termo = nome.trim();

    if (termo.isEmpty) {
      throw Exception('Digite o nome de uma receita.');
    }

    final url = Uri.parse(
      '$baseUrl/search',
    ).replace(
      queryParameters: {'q': termo},
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados is! Map<String, dynamic> ||
          dados['recipes'] is! List) {
        throw Exception('Formato de resposta inválido.');
      }

      final List receitasJson = dados['recipes'];

      return receitasJson
          .whereType<Map<String, dynamic>>()
          .map((json) => Receita.fromJson(json))
          .toList();
    } else {
      throw Exception('Erro ao pesquisar receitas.');
    }
  }

  Future<Receita> buscarReceitaPorId(int id) async {
    final url = Uri.parse('$baseUrl/$id');

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados is! Map<String, dynamic>) {
        throw Exception('Formato de resposta inválido.');
      }

      return Receita.fromJson(dados);
    } else {
      throw Exception('Erro ao buscar detalhes da receita.');
    }
  }
}
