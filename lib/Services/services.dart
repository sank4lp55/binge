import 'dart:convert';
import 'package:binge/Model/movie_list_model.dart';
import 'package:http/http.dart' as http;

const apiKey = "e2994afb1f878705c2a5cf3f71716c1a";

class APIservices {
  final nowShowingApi =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";
  final upComingApi =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApi =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  // for nowShowing moveis
  Future<MovieListModel> getNowShowing() async {
    Uri url = Uri.parse(nowShowingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return MovieListModel.fromJson(json.decode(response.body));
    } else {
      // If the server does not return a 200 OK response, throw an exception
      throw Exception('Failed to load now playing movies');
    }
  }

  // for up coming moveis
  Future<MovieListModel> getUpComing() async {
    Uri url = Uri.parse(upComingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return MovieListModel.fromJson(json.decode(response.body));
    } else {
      // If the server does not return a 200 OK response, throw an exception
      throw Exception('Failed to load now playing movies');
    }
  }

  // for popular moves
  Future<MovieListModel> getPopular() async {
    Uri url = Uri.parse(popularApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return MovieListModel.fromJson(json.decode(response.body));
    } else {
      // If the server does not return a 200 OK response, throw an exception
      throw Exception('Failed to load now playing movies');
    }
  }
}
