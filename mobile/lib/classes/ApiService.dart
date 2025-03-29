import 'dart:convert';
import 'package:http/http.dart' as http;

String TOKEN = "";

class ApiService {
  // temp token for testing
  //String TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3ZTU1YzJlOTFlMDAxZWExYjljYjFiMyIsInVzZXJuYW1lIjoiYWJjIiwiaWF0IjoxNzQzMjAyNTk0LCJleHAiOjE3NDMyMDYxOTR9.xo0jVb2htDh_sjNzUsYC05AOzeyVe5aQKbbIQ3QhnGE";
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
        Uri.parse('$baseUrl/getTeams/$query?limit=8&offset=$offset'),
        headers: {'Authorization': 'Bearer $TOKEN'},
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
        headers: {'Authorization': 'Bearer $TOKEN'},
      );
    });
  }

  Future<void> editTeamName(String teamId, String newTeamName) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/updateTeam/$teamId'),
        headers: {
          'Authorization': 'Bearer $TOKEN',
          'Content-Type': 'application/json',
        },
        body: json.encode({'newTeamName': newTeamName}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to update team name');
      }
    } catch (error) {
      throw Exception('Error occurred: $error');
    }
  }

  // delete team
  Future<void> deleteTeam(String teamId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deleteTeam/$teamId'),
        headers: {
          'Authorization': 'Bearer $TOKEN',
        },
      );

      if (response.statusCode == 200) {
        print('Team deleted successfully.');
      } else {
        throw Exception('Failed to delete team');
      }
    } catch (error) {
      throw Exception('Error occurred: $error');
    }
  }

  //ADD TEAM
  
  // ADD TEAM
Future<Map<String, dynamic>> addTeam(String teamName) async {
  if (teamName.isEmpty) {
    throw Exception('Team name is required.');
  }

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/addTeam'),
      headers: {
        'Authorization': 'Bearer $TOKEN',
        'Content-Type': 'application/json',
      },
      body: json.encode({'teamName': teamName}),
    );

    if (response.statusCode == 201) { 
      // Parse the response body and return it as a map
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to add team');
    }
  } catch (error) {
    throw Exception('Error occurred: $error');
  }
}

} 
