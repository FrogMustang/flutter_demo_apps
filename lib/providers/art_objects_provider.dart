import 'package:flutter/material.dart';
import 'package:flutter_demo_apps/models/art_object.dart';
import 'package:flutter_demo_apps/repository/museum_repository.dart';
import 'package:http/http.dart' as http;

class ArtObjectsProvider extends ChangeNotifier {
  final MuseumRepository _museumApi;

  final httpClient = http.Client();

  ArtObjectsProvider(this._museumApi);

  /// Dummy art object, instead of null.
  /// Placeholder data until actual data is fetched
  ArtObject? artObject;

  /// List with the sections in the HomeScreen
  final List<String> _sections = ["sculptures", "photographs", "paintings"];

  /// List to keep track of sculptures
  final Set<ArtObject> _sculptures = {};

  /// List to keep track of photographs
  final Set<ArtObject> _photographs = {};

  /// List to keep track of paintings
  final Set<ArtObject> _paintings = {};

  Set<ArtObject> get sculptures => _sculptures;

  Set<ArtObject> get photographs => _photographs;

  Set<ArtObject> get paintings => _paintings;

  /// Keep track of the section we are currently fetching items for
  int k = -1;

  /// Check for fetching overlaps to avoid multiple calls
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  /// Check if there is still data left to be fetched
  bool _dataLeft = false;

  // Start with -1, because the first time it gets incremented to 0
  int _page = -1;

  /// Fetch objects from [page] with a set limit of [itemsOnPage] items per page
  /// and update [_artObjects] in the ArtObjectsProvider
  Future<void> getObjects(int itemsOnPage) async {
    /// if there is no data left, try and get items for the next section
    if (!_dataLeft && k < _sections.length - 1) {
      // if we haven't reached the end of the sections list, there is data left
      _dataLeft = true;
      _page++;
      k++;
      _isFetching = true; // notify fetching started
      notifyListeners();

      _getData(_page, itemsOnPage, _sections[k]);
    } else if (_dataLeft) {
      _isFetching = true;
      _page++;
      notifyListeners();

      _getData(_page, itemsOnPage, _sections[k]);
    }
  }

  /// Method used to fetch the data and avoid code duplication
  _getData(int page, int itemsOnPage, String objectType) async {
    // fetch art objects
    dynamic res = await _museumApi
        .fetchArtObjects(httpClient, page, itemsOnPage, objectType)
        // throw it up the chain
        .catchError((error) => Future.error(error));

    // parse te result and convert it to List<ArtObject>
    res = ArtObject.fromJSON(res);

    // update result and notify method end
    switch (k) {
      case 0:
        _sculptures.addAll(res);
        break;

      case 1:
        _photographs.addAll(res);
        break;

      case 2:
        _paintings.addAll(res);
        break;
      default:
        break;
    }
    // print("SCULPTURES: $_sculptures");

    _isFetching = false;
    _dataLeft = res.isNotEmpty;

    // cap it off at 15 items
    if (_sculptures.length >= 15 ||
        _photographs.length >= 15 ||
        _paintings.length >= 15) _dataLeft = false;
    notifyListeners();
  }

  /// Fetch object details for [artObject]
  Future<void> getObjectDetails(ArtObject obj) async {
    /// notify fetching started
    _isFetching = true;
    notifyListeners();

    /// fetch art objects
    dynamic res = await _museumApi
        .fetchObjectDetails(httpClient, obj.objNr)
        // throw it up the chain
        .catchError((error) => Future.error(error));

    /// update art object in the list with the details
    res = ArtObject.fromJSONSingle(res, obj);
    artObject = obj.copyWith(
      label: res.label,
      description: res.description,
      types: res.types,
      materials: res.materials,
      maker: res.maker,
      date: res.date,
    );

    _isFetching = false;
    notifyListeners();
  }
}
