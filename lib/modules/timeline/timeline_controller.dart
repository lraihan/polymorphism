import 'package:get/get.dart';
import 'package:polymorphism/data/models/career_event.dart';

/// Controller for managing timeline state and interactions
class TimelineController extends GetxController {
  /// List of career events to display
  final List<CareerEvent> events = CareerEvent.sampleEvents;

  /// Currently active/highlighted timeline event index
  final RxInt activeIndex = 0.obs;

  /// Whether the timeline is currently being scrolled by user
  final RxBool isScrolling = false.obs;

  /// Update the active index based on scroll position
  void updateActiveIndex(int index) {
    if (index >= 0 && index < events.length) {
      activeIndex.value = index;
    }
  }

  // ignore: avoid_positional_boolean_parameters, use_setters_to_change_properties
  void setScrolling(bool scrolling) {
    isScrolling.value = scrolling;
  }

  /// Get event at specific index
  CareerEvent? getEventAt(int index) {
    if (index >= 0 && index < events.length) {
      return events[index];
    }
    return null;
  }

  /// Get the currently active event
  CareerEvent? get activeEvent => getEventAt(activeIndex.value);

  /// Reset to first event
  void reset() {
    activeIndex.value = 0;
    isScrolling.value = false;
  }

  /// Navigate to specific event index
  void navigateToEvent(int index) {
    updateActiveIndex(index);
  }

  /// Get total number of events
  int get eventCount => events.length;

  /// Check if given index is the active one
  bool isActive(int index) => activeIndex.value == index;

  /// Get next event index (with wrapping)
  int get nextIndex => (activeIndex.value + 1) % events.length;

  /// Get previous event index (with wrapping)
  int get previousIndex => activeIndex.value == 0 ? events.length - 1 : activeIndex.value - 1;
}
