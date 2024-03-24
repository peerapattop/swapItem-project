import 'dart:async';

import '../models/place_autocomplete_model.dart';
import '../repositories/places/places_repository.dart';
import 'autocomplete_event.dart';
import 'autocomplete_state.dart';

class AutocompleteBloc {
  //Classes can only extend other classes. (Documentation)  Try specifying a different superclass, or removing the extends clause.
  final PlacesRepository _placesRepository;
  StreamSubscription? _placesSubscription;
  AutocompleteBloc({required PlacesRepository placesRepository})
      : _placesRepository = placesRepository,
        super(); //Too many positional arguments: 0 expected, but 1 found. (Documentation)  Try removing the extra arguments.
  @override
  Stream<AutocompleteState> mapEventToState(
    AutocompleteEvent event,
  ) async* {
    if (event is LoadAutocomplete) {
      yield* _mapLoadAutocompleteToState(event);
    }
  }

  Stream<AutocompleteState> _mapLoadAutocompleteToState(
      LoadAutocomplete event) async* {
    _placesSubscription?.cancel();

    final List<PlaceAutocomplete>? autocomplete =
        await _placesRepository.getPlaceAutocomplete(event.searchinput);
    yield AutocompleteLoaded(autocomplete: autocomplete!);
  }
}
