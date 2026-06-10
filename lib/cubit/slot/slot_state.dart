import '../../models/slot.dart';

abstract class SlotState {}

class SlotInitial extends SlotState {}

class SlotLoading extends SlotState {}

class SlotLoaded extends SlotState {
  final List<Slot> slots;
  SlotLoaded(this.slots);
}

class SlotError extends SlotState {
  final String message;
  SlotError(this.message);
}