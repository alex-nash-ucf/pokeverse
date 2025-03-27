import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // temp token for testing
  String TOKEN = "";
  static const String baseUrl = 'http://157.230.80.230:5001';

  // ERRO HANDLING
  Future<List<dynamic>> _handleRequest(
    Future<http.Response> Function() requestFunction,
  ) async {
    try {
      final response = await requestFunction();

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error occurred: $error');
    }
  }

  // TEAMS
  Future<List<dynamic>> fetchTeams(String query, {int offset = 0}) async {
    return await _handleRequest(() async {
      return await http.get(
        Uri.parse('$baseUrl/getTeams'),
        headers: {
          'Authorization': 'Bearer $TOKEN',
        },
      );
    });
  }

  // POKEMON
  Future<List<dynamic>> searchPokemon(String query, {int offset = 0}) async {
    return await _handleRequest(() async {
      return await http.get(
        Uri.parse('$baseUrl/pokemon/search/$query?limit=8&offset=$offset'),
      );
    });
  }

  // HANDLE REQUEST
  Future<List<dynamic>> getPokemonByTeamId(String teamId) async {
    return await _handleRequest(() async {
      return await http.get(
        Uri.parse('$baseUrl/getPokemon/$teamId'),
        headers: {
          'Authorization': 'Bearer $TOKEN',
        },
      );
    });
  }
}
