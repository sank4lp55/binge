import 'package:binge/Model/movie_list_model.dart';
import 'package:binge/Screen/movie_detail_screen.dart';
import 'package:binge/Screen/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../Controllers/movie_controller.dart';
import 'scanner_screen.dart'; // Import the ScannerScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController =
        Provider.of<MovieController>(context, listen: false);

    // Fetching movies when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieController.fetchNowShowingMovies();
      movieController.fetchUpComingMovies();
      movieController.fetchPopularMovies();
    });

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text("bINGE"),
        leading: const Icon(Icons.menu),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => SearchScreen(
                    upComingMovies: movieController.upComingMovies,
                    nowShowingMovies: movieController.nowShowingMovies,
                    popularMovies: movieController.popularMovies,
                  ),
                ),
              );
            },
            child: const Icon(Icons.search_rounded),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.notifications),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "  Now Playing",
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScannerScreen()),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCarousel(BuildContext context, String category) {
    return Consumer<MovieController>(
      builder: (context, movieController, child) {
        MovieListModel? movieListModel = movieController.nowShowingMovies;

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

        if (movieListModel?.movies == null || movieListModel!.movies!.isEmpty) {
          return const Center(
            child: Text('No movies available'),
          );
        }

        return CarouselSlider.builder(
          itemCount: movieListModel?.movies!.length,
          itemBuilder: (context, index, movieIndex) {
            final movie = movieListModel?.movies![index];
            return InkWell(
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      // Clip the image to the border radius
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/original/${movie?.backdropPath}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Text(
                      movie?.title ?? "",
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
              ),
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
        MovieListModel? movieListModel;

        if (category == 'upComing') {
          movieListModel = movieController.upComingMovies;
        } else if (category == 'popularMovies') {
          movieListModel = movieController.popularMovies;
        } else {
          return const Center(child: Text('Invalid category'));
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

        if (movieListModel?.movies == null || movieListModel!.movies!.isEmpty) {
          return const Center(
            child: Text('No movies available'),
          );
        }

        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieListModel.movies!.length,
            itemBuilder: (context, index) {
              final movie = movieListModel?.movies![index];
              return InkWell(
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 300,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        // Clip the image to the border radius
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://image.tmdb.org/t/p/original/${movie?.backdropPath}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Center(child: Icon(Icons.error)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Text(
                        movie?.title ?? "",
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
