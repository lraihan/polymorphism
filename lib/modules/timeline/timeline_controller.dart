import 'package:get/get.dart';
import 'package:polymorphism/data/models/career_event.dart';

class TimelineController extends GetxController {
  final List<CareerEvent> events = CareerEvent.sampleEvents;

  final RxInt activeIndex = 0.obs;

  final RxBool isScrolling = false.obs;

  void updateActiveIndex(int index) {
    if (index >= 0 && index < events.length) {
      activeIndex.value = index;
    }
  }

  // ignore: avoid_positional_boolean_parameters, use_setters_to_change_properties
  void setScrolling(bool scrolling) {
    isScrolling.value = scrolling;
  }

  CareerEvent? getEventAt(int index) {
    if (index >= 0 && index < events.length) {
      return events[index];
    }
    return null;
  }

  CareerEvent? get activeEvent => getEventAt(activeIndex.value);

  void reset() {
    activeIndex.value = 0;
    isScrolling.value = false;
  }

  void navigateToEvent(int index) {
    updateActiveIndex(index);
  }

  int get eventCount => events.length;

  bool isActive(int index) => activeIndex.value == index;

  int get nextIndex => (activeIndex.value + 1) % events.length;

  int get previousIndex => activeIndex.value == 0 ? events.length - 1 : activeIndex.value - 1;
}
