import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../Controllers/movie_controller.dart';
import '../Model/movie_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController = Provider.of<MovieController>(context, listen: false);

    // Fetching movies when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieController.fetchNowShowingMovies();
      movieController.fetchUpComingMovies();
      movieController.fetchPopularMovies();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie App"),
        leading: const Icon(Icons.menu),
        centerTitle: true,
        actions: const [
          Icon(Icons.search_rounded),
          SizedBox(width: 20),
          Icon(Icons.notifications),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "  Now Showing",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildCarousel(context, 'nowShowing'),
              const SizedBox(height: 20),
              const Text(
                "  Up Coming Movies",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              _buildListView(context, 'upComing'),
              const SizedBox(height: 10),
              const Text(
                "  Popular Movies",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              _buildListView(context, 'popularMovies'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, String category) {
    return Consumer<MovieController>(
      builder: (context, movieController, child) {
        List<Movie> movies = [];
        if (category == 'nowShowing') {
          movies = movieController.nowShowingMovies;
        }

        if (movieController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (movieController.error.isNotEmpty) {
          return Center(
            child: Text(movieController.error),
          );
        }

        if (movies.isEmpty) {
          return const Center(
            child: Text('No movies available'),
          );
        }

        return CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, movieIndex) {
            final movie = movies[index];
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 1.7,
            autoPlayInterval: const Duration(seconds: 5),
          ),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, String category) {
    return Consumer<MovieController>(
      builder: (context, movieController, child) {
        List<Movie> movies = [];
        if (category == 'upComing') {
          movies = movieController.upComingMovies;
        } else if (category == 'popularMovies') {
          movies = movieController.popularMovies;
        }

        if (movieController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (movieController.error.isNotEmpty) {
          return Center(
            child: Text(movieController.error),
          );
        }

        if (movies.isEmpty) {
          return const Center(
            child: Text('No movies available'),
          );
        }

        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Stack(
                children: [
                  Container(
                    width: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Text(
                      movie.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
