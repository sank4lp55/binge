import 'package:flutter/material.dart';
import '../Model/movie_list_model.dart';
import '../Widgets/my_textfield.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final MovieListModel? nowShowingMovies;
  final MovieListModel? upComingMovies;
  final MovieListModel? popularMovies;

  const SearchScreen({
    Key? key,
    this.nowShowingMovies,
    this.upComingMovies,
    this.popularMovies,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> _allMovies = [];
  List<Movie> _searchResults = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _combineMovies();
    _searchController.addListener(_onSearchChanged); // Listen for changes
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterMovies(_searchController.text);
  }

  // Combine movies from the three categories into one list
  void _combineMovies() {
    final List<Movie> allMovies = [];

    if (widget.nowShowingMovies?.movies != null) {
      allMovies.addAll(widget.nowShowingMovies!.movies!);
    }
    if (widget.upComingMovies?.movies != null) {
      allMovies.addAll(widget.upComingMovies!.movies!);
    }
    if (widget.popularMovies?.movies != null) {
      allMovies.addAll(widget.popularMovies!.movies!);
    }

    setState(() {
      _allMovies = allMovies;
      _searchResults = allMovies; // Initially, show all movies
    });
  }

  // Filter movies based on the search query
  void _filterMovies(String query) {
    if (query.isNotEmpty) {
      final List<Movie> filteredMovies = _allMovies.where((movie) {
        return movie.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
      setState(() {
        _searchResults = filteredMovies;
      });
    } else {
      // If the query is empty, show all movies again
      setState(() {
        _searchResults = _allMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text('Search Movies'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MyTextField(
              padding: 5,
              controller:  _searchController,
              hintText: 'Search',
              obscureText: false,
            ),


          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return ListTile(
                  onTap: (){
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                  leading: Image.network(
                    "https://image.tmdb.org/t/p/w200/${movie.posterPath}",
                    fit: BoxFit.cover,
                    width: 50,
                    height: 75,
                  ),
                  title: Text(movie.title ?? 'Unknown Title'),
                  subtitle:
                  Text('Release Date: ${movie.releaseDate ?? "N/A"}'),
                );
              },
            )
                : const Center(
              child: Text('No movies found'),
            ),
          ),
        ],
      ),
    );
  }
}
