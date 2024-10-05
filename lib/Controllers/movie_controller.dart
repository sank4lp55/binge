import 'package:flutter/material.dart';

import '../Model/movie_model.dart';
import '../Services/services.dart';

class MovieController with ChangeNotifier {
  final APIservices _apiServices = APIservices();

  List<Movie> _nowShowingMovies = [];
  List<Movie> _upComingMovies = [];
  List<Movie> _popularMovies = [];

  String _error = '';
  bool _isLoading = false;

  // Getters to access the movie lists and status
  List<Movie> get nowShowingMovies => _nowShowingMovies;
  List<Movie> get upComingMovies => _upComingMovies;
  List<Movie> get popularMovies => _popularMovies;
  String get error => _error;
  bool get isLoading => _isLoading;

  // Method to fetch now showing movies
  Future<void> fetchNowShowingMovies() async {
    _setLoading(true);
    try {
      _nowShowingMovies = await _apiServices.getNowShowing();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Method to fetch upcoming movies
  Future<void> fetchUpComingMovies() async {
    _setLoading(true);
    try {
      _upComingMovies = await _apiServices.getUpComing();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Method to fetch popular movies
  Future<void> fetchPopularMovies() async {
    _setLoading(true);
    try {
      _popularMovies = await _apiServices.getPopular();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Setters for loading state and error handling
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String value) {
    _error = value;
    notifyListeners();
  }
}
