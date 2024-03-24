import '../../models/place_autocomplete_model.dart';
import 'base_places_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class PlacesRepository extends BasePlacesRepository {
  final String key = 'AIzaSyCPXJBrIkoDha7W7-4VwAF1b-fkBobxTX0';
  final String type = 'geocode';

  Future<List<PlaceAutocomplete>> getPlaceAutocomplete(
      String searchinput) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchinput&types=$type&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var Results = json['predictions'] as List;
    return Results.map((place) => PlaceAutocomplete.fromJson(place)).toList();
  }
}