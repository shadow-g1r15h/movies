import 'package:flutter/foundation.dart';

class Environment {
  Environment._privateConstructor();
  static final Environment _instance = Environment._privateConstructor();
  static Environment get instance => _instance;

  String get fileName {
    if (kReleaseMode == true) {
      return '.env.production';
    }
    return '.env.development';
  }

  String get moviesBaseURL {
    return 'https://api.themoviedb.org/3/movie/popular?api_key=e2c0b0ec8ae74105847175eb993d0da1&language=en-US&page=1';
  }

  String get upcomingMoviesURL {
    return 'https://api.themoviedb.org/3/movie/now_playing?api_key=e2c0b0ec8ae74105847175eb993d0da1&language=en-US&page=1';
  }

  String get searchMoviesURL {
    return 'https://api.themoviedb.org/3/search/movie?api_key=e2c0b0ec8ae74105847175eb993d0da1&language=en-US&';
  }
}
