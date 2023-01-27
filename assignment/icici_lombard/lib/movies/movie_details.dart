import 'package:flutter/material.dart';

class MovieDetails extends StatefulWidget {
  final int index;
  final dynamic movieDetails;
  const MovieDetails({
    required this.index,
    required this.movieDetails,
    Key? key,
  }) : super(key: key);
  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  height: MediaQuery.of(context).size.height / 1.8,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/original${widget.movieDetails['poster_path']}'),
                          fit: BoxFit.cover)),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    widget.movieDetails['original_title'],
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Text(
                    widget.movieDetails['overview'],
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'IMDB rating: ${widget.movieDetails['vote_average'].toString()}',
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'Release Date: ${widget.movieDetails['release_date']}',
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
