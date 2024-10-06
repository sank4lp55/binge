import 'dart:convert';
import 'package:binge/Model/movie_list_model.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Add this import
import '../Services/services.dart';

class MovieController with ChangeNotifier {
  final APIservices _apiServices = APIservices();

  MovieListModel? _nowShowingMovies;
  MovieListModel? _upComingMovies;
  MovieListModel? _popularMovies;
  MovieListModel? _topRatedMovies;
  String _error = '';
  bool _isLoading = false;

  // Getters to access the movie lists and status
  MovieListModel? get nowShowingMovies => _nowShowingMovies;

  MovieListModel? get upComingMovies => _upComingMovies;

  MovieListModel? get popularMovies => _popularMovies;
  MovieListModel? get topRatedMovies => _topRatedMovies;

  String get error => _error;

  bool get isLoading => _isLoading;

  // Method to fetch now showing movies
  Future<void> fetchNowShowingMovies() async {
    _setLoading(true);

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.none) {
        // Offline, try to load cached data
        String? cachedData =
            await _apiServices.getCachedData('now_showing_movies');
        if (cachedData != null) {
          _nowShowingMovies = MovieListModel.fromJson(json.decode(cachedData));

          _setError(
              'Loaded cached data. Please check your internet connection.');
        } else {
          _setError('No internet connection and no cached data available.');
        }
        _error = '';
        _setLoading(false);
      } else {
        _nowShowingMovies = await _apiServices.getNowShowing();
        _error = '';
      }
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
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.none) {
        // Offline, try to load cached data
        String? cachedData =
        await _apiServices.getCachedData('upcoming_movies');
        if (cachedData != null) {
          _upComingMovies = MovieListModel.fromJson(json.decode(cachedData));

          _setError(
              'Loaded cached data. Please check your internet connection.');
        } else {
          _setError('No internet connection and no cached data available.');
        }
        _error = '';
        _setLoading(false);
      } else {
        _upComingMovies = await _apiServices.getUpComing();
        _error = '';
      }
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
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.none) {
        // Offline, try to load cached data
        String? cachedData =
        await _apiServices.getCachedData('popular_movies');
        if (cachedData != null) {
          _popularMovies = MovieListModel.fromJson(json.decode(cachedData));

          _setError(
              'Loaded cached data. Please check your internet connection.');
        } else {
          _setError('No internet connection and no cached data available.');
        }
        _error = '';
        _setLoading(false);
      } else {
        _popularMovies = await _apiServices.getPopular();
        _error = '';
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Method to fetch top rated movies
  Future<void> fetchTopRatedMovies() async {
    _setLoading(true);

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.none) {
        // Offline, try to load cached data
        String? cachedData =
        await _apiServices.getCachedData('top_rated');
        if (cachedData != null) {
          _topRatedMovies = MovieListModel.fromJson(json.decode(cachedData));

          _setError(
              'Loaded cached data. Please check your internet connection.');
        } else {
          _setError('No internet connection and no cached data available.');
        }
        _error = '';
        _setLoading(false);
      } else {
        _topRatedMovies = await _apiServices.getTopRated();
        _error = '';
      }
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
