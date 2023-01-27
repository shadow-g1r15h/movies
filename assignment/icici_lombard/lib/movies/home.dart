import 'package:flutter/material.dart';
import 'package:icici_lombard/Provider/movie_provider.dart';
import 'package:icici_lombard/movies/movie_details.dart';
import 'package:icici_lombard/movies/search_movies.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  @override
  void initState() {
    fetchPopularMovies();
    fetchUpcomingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text("Movies Now"),
        leading: const Icon(Icons.ac_unit_rounded),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchMovies()),
              );
            },
            icon: const Icon(Icons.search),
          ),
          const Icon(Icons.account_circle_rounded),
          const SizedBox(width: 10)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black,
              height: 1000,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _carouselSlider(context),
                        const SizedBox(height: 60),
                        _popularMovies(context),
                        const SizedBox(height: 30),
                        _upcomingMovies(context)
                      ],
                    )),
        ),
      ),
    );
  }

  Widget _popularMovies(BuildContext context) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Movies",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(
          width: 500,
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 500,
              height: 200,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: movieApi.popularMovies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _popularMovie(context, index);
                  }),
            ),
          ),
        )
      ],
    );
  }

  Widget _popularMovie(BuildContext context, int index) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    print({
      'https://image.tmdb.org/t/p/original${movieApi.popularMovies[index]['poster_path']}',
      "image path"
    });
    return GestureDetector(
      child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.black,
          ),
          margin: const EdgeInsets.only(left: 5.0),
          child: Image.network(
              'https://image.tmdb.org/t/p/original${movieApi.popularMovies[index]['poster_path']}')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MovieDetails(
                  index: index, movieDetails: movieApi.popularMovies[index])),
        );
      },
    );
  }

  Widget _upcomingMovies(BuildContext context) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Movies",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        SizedBox(
          width: 500,
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 500,
              height: 200,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: movieApi.upcomingMovies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _upcomingMovie(context, index);
                  }),
            ),
          ),
        )
      ],
    );
  }

  Widget _upcomingMovie(BuildContext context, int index) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    return GestureDetector(
      child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.black,
          ),
          margin: const EdgeInsets.all(5.0),
          // child: const Image(image: AssetImage('assets/images/poster.jpg'))),
          child: Image.network(
              'https://image.tmdb.org/t/p/original${movieApi.upcomingMovies[index]['poster_path']}')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MovieDetails(
                  index: index, movieDetails: movieApi.upcomingMovies[index])),
        );
      },
    );
  }

  Widget _carouselSlider(BuildContext context) {
    return CarouselSlider(
      items: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/images/avatar.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/images/endgame.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              image: AssetImage('assets/images/poc.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        height: 380.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }

  Future<void> fetchPopularMovies() async {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await movieApi.getMovieDetails(context: context);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchUpcomingMovies() async {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await movieApi.getUpcomingMovieDetails(context: context);
    setState(() {
      isLoading = false;
    });
  }
}
