import '../../models/venue.dart';

abstract class VenueState {}

class VenueInitial extends VenueState {}

class VenueLoading extends VenueState {}

class VenueLoaded extends VenueState {
  final List<Venue> venues;
  VenueLoaded(this.venues);
}

class VenueError extends VenueState {
  final String message;
  VenueError(this.message);
}