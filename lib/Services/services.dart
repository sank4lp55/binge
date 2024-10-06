import 'dart:convert';
import 'package:binge/Model/movie_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const apiKey = "e2994afb1f878705c2a5cf3f71716c1a";

class APIservices {
  final nowShowingApi =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";
  final upComingApi =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApi =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";

  // Store fetched data locally
  Future<void> cacheData(String key, String jsonData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonData);
  }

  // Retrieve cached data
  Future<String?> getCachedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<MovieListModel> getNowShowing() async {
    Uri url = Uri.parse(nowShowingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Cache data locally
      await cacheData('now_showing_movies', response.body);
      return MovieListModel.fromJson(json.decode(response.body));
    } else {
      // Attempt to retrieve cached data if the API call fails
      String? cachedData = await getCachedData('now_showing_movies');
      if (cachedData != null) {
        return MovieListModel.fromJson(json.decode(cachedData));
      }
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<MovieListModel> getUpComing() async {
    Uri url = Uri.parse(upComingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Cache data locally
      await cacheData('upcoming_movies', response.body);
      return MovieListModel.fromJson(json.decode(response.body));
    } else {
      // Attempt to retrieve cached data if the API call fails
      String? cachedData = await getCachedData('upcoming_movies');
      if (cachedData != null) {
        return MovieListModel.fromJson(json.decode(cachedData));
      }
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<MovieListModel> getPopular() async {
    Uri url = Uri.parse(popularApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Cache data locally
      await cacheData('popular_movies', response.body);
      return MovieListModel.fromJson(json.decode(response.body));
    } else {
      // Attempt to retrieve cached data if the API call fails
      String? cachedData = await getCachedData('popular_movies');
      if (cachedData != null) {
        return MovieListModel.fromJson(json.decode(cachedData));
      }
      throw Exception('Failed to load popular movies');
    }
  }
}
