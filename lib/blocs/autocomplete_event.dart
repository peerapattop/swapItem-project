import 'package:equatable/equatable.dart';

abstract class AutocompleteEvent extends Equatable {
  const AutocompleteEvent();
  @override
  List<Object> get props => [];
}

class LoadAutocomplete extends AutocompleteEvent {
  final String searchinput;
  LoadAutocomplete({this.searchinput = ''});
  @override
  List<Object> get props => [searchinput];
}
