import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MuseumRepository {
  String apiKey = "0fiuZFh4";

  /// Make API call to fetch art objects from page nr. [page]
  /// with [itemsOnPage] art objects on each page
  Future<dynamic> fetchArtObjects(
    http.Client httpClient,
    int page,
    int itemsOnPage,
    String objectType,
  ) async {
    debugPrint("Make API request to fetch data from page: $page");

    http.Response response = await httpClient.get(
      Uri.https(
          "rijksmuseum.nl",
          "/api/nl/collection?key=$apiKey&culture=en&imgonly=True&toppieces=True&"
              "p=$page&ps=$itemsOnPage&q=$objectType"),
    );

    debugPrint("Fetch art objects RESP STATUS CODE: ${response.statusCode}");

    /// if something fails
    if (response.statusCode != 200) {
      /// if something fails, throw it up the chain
      /// and handle it in the UI code where the first call is made
      return Future.error("Failed to fetch art objects");
    } else {
      // log("RESPONSE OBJECTS: ${JsonEncoder.withIndent("     ")
      //     .convert(json.decode(response.body))}");
      return json.decode(response.body);
    }
  }

  /// Make API call to fetch object details
  Future<dynamic> fetchObjectDetails(
      http.Client httpClient, String objId) async {
    debugPrint("Fetch objects details for: $objId");

    http.Response response = await httpClient.get(
      Uri.https("rijksmuseum.nl", "/api/nl/collection/$objId?key=$apiKey"),
    );

    debugPrint("Fetch object details RESP STATUS CODE: ${response.statusCode}");

    /// if something fails
    if (response.statusCode != 200) {
      debugPrint("REASON PHRASE: " + response.reasonPhrase!);

      /// if something fails, throw it up the chain
      /// and handle it in the UI code where the first call is made
      return Future.error("Failed to fetch object details");
    } else {
      // log("RESPONSE OBJECTS: ${JsonEncoder.withIndent("     ")
      //     .convert(json.decode(response.body))}");
      return json.decode(response.body);
    }
  }
}
