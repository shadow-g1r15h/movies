import 'package:flutter/material.dart';
import 'package:icici_lombard/movies/movie_details.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../Provider/movie_provider.dart';

class SearchMovies extends StatefulWidget {
  const SearchMovies({super.key});

  @override
  State<SearchMovies> createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<SearchMovies> {
  int searchListLength = 0;
  Timer? _debounce;
  List<String> dropDown = <String>["Default", "Date", "Ratings"];
  String sortMethod = "Default";
  List<dynamic> sortedList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void sort(String method) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    switch (method) {
      case 'Date':
        {
          setState(() {
            // sort by date
            sortedList.sort((a, b) {
              var adate = a['release_date'];
              var bdate = b['release_date'];
              return -adate.compareTo(bdate);
            });
          });
          break;
        }
      case 'Ratings':
        {
          // sort by ratings
          sortedList.sort((a, b) {
            var arating = a['vote_average'];
            var brating = b['vote_average'];
            return -arating.compareTo(brating);
          });
          break;
        }
      case 'Default':
        {
          // default sort
          setState(() {
            sortedList = movieApi.searchMovies;
          });
          break;
        }
      default:
        {
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
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
              color: Colors.black,
              child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                        prefixIcon: IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        hintText: "Search for a movie",
                        border: InputBorder.none),
                    onChanged: (String text) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce =
                          Timer(const Duration(milliseconds: 1000), () async {
                        await searchMovies(text);
                        setState(() {
                          searchListLength = movieApi.searchMovies.length;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Center(
                          child: DropdownButton(
                              underline: Container(),
                              icon: const Icon(Icons.sort, color: Colors.white),
                              iconSize: 30,
                              items: dropDown.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                sort(value.toString());
                                setState(() {
                                  sortMethod = value.toString();
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  searchListLength != 0 ? _searchOption(context) : Container()
                ],
              )),
        ),
      ),
    );
  }

  Widget _searchOption(BuildContext context) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: sortedList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  searchedMovie(context, index),
                  const SizedBox(height: 3)
                ],
              );
            }),
      ),
    );
  }

  Widget searchedMovie(BuildContext context, int index) {
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        color: const Color.fromARGB(255, 20, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/original${movieApi.searchMovies[index]['poster_path']}'),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(width: 20),
            Text(
              movieApi.searchMovies[index]['original_title'],
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MovieDetails(
                  index: index, movieDetails: movieApi.searchMovies[index])),
        );
      },
    );
  }

  Future<void> searchMovies(String query) async {
    String searchString = query.replaceAll(RegExp(' +'), '%20');
    var movieApi = Provider.of<MovieApi>(context, listen: false);
    await movieApi.searchMovie(context: context, query: searchString);
    setState(() {
      sortedList = movieApi.searchMovies;
    });
  }
}
