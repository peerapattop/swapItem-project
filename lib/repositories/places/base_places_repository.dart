import 'package:swapitem/models/place_autocomplete_model.dart';

abstract class BasePlacesRepository {
  Future<List<PlaceAutocomplete>?> getPlaceAutocomplete(String searchinput);
}
