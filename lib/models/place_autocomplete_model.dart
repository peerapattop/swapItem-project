class PlaceAutocomplete {
  final String placeId;
  final String description;

  PlaceAutocomplete({required this.description, required this.placeId});

  factory PlaceAutocomplete.fromJson(Map<String, dynamic> json) {
    return PlaceAutocomplete(
      placeId: json['description'],
      description: json['place_id'],
    );
  }
}
