import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import '../common/snackbar_message.dart';
import '../models/environment.dart';

class MovieApi extends ChangeNotifier {
  Client http = Client();
  final Map<String, String> _commonHeaders = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };
  bool isLoading = false;

  List<dynamic> popularMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> searchMovies = [];

  final String popularMoviesURL = Environment.instance.moviesBaseURL;
  final String searchMoviesURL = Environment.instance.searchMoviesURL;
  final String upcomingMoviesURL = Environment.instance.upcomingMoviesURL;

  Future<void> getMovieDetails({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      Uri uri = Uri.parse(popularMoviesURL);
      Response response = await http.get(
        uri,
        headers: _commonHeaders,
      );
      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        popularMovies = res['results'];
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == 200 && res['data'].isEmpty) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance.showMessage(
            context: context, message: "Error fetching project details.");
      } else if (response.statusCode == 500) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance
            .showMessage(context: context, message: "Server Error.");
      } else if (response.statusCode == 400) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance.showMessage(
            context: context,
            message:
                "Error fetching movie details, please restart the application.");
      }
      isLoading = false;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUpcomingMovieDetails({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();
      Uri uri = Uri.parse(upcomingMoviesURL);
      Response response = await http.get(
        uri,
        headers: _commonHeaders,
      );
      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        upcomingMovies = res['results'];
        upcomingMovies.shuffle();
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == 200 && res['data'].isEmpty) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance.showMessage(
            context: context, message: "Error fetching project details.");
      } else if (response.statusCode == 500) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance
            .showMessage(context: context, message: "Server Error.");
      } else if (response.statusCode == 400) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance.showMessage(
            context: context,
            message:
                "Error fetching movie details, please restart the application.");
      }
      isLoading = false;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovie(
      {required BuildContext context, required String query}) async {
    try {
      isLoading = true;
      notifyListeners();
      Uri uri =
          Uri.parse('$searchMoviesURL&query=$query&page=1&include_adult=false');
      Response response = await http.get(
        uri,
        headers: _commonHeaders,
      );
      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        searchMovies = res['results'];
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == 200 && res['results'].isEmpty) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance
            .showMessage(context: context, message: "No Movies found.");
      } else if (response.statusCode == 500) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance
            .showMessage(context: context, message: "Server Error.");
      } else if (response.statusCode == 400) {
        isLoading = false;
        notifyListeners();
        SnackBarMessage.instance.showMessage(
            context: context,
            message:
                "Error fetching movie details, please restart the application.");
      }
      isLoading = false;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      notifyListeners();
    }
  }
}
