import 'package:get/get.dart';
import 'package:emarates_bd/app/modules/events/controllers/event_controller.dart';
import 'package:emarates_bd/app/modules/events/controllers/events_controller.dart';
import 'package:emarates_bd/app/modules/favorites/controllers/favorites_controller.dart';

import '../../account/controllers/account_controller.dart';
import '../../bookings/controllers/booking_controller.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.put(HomeController(), permanent: true);
    Get.put(EventsController(), permanent: true);
    // Get.put(BookingsController(), permanent: true);

    Get.lazyPut<EventController>(
      () => EventController(),
      // () => BookingController(),
    );
    // Get.lazyPut<MessagesController>(
    //   () => MessagesController(),
    // );
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(),
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.lazyPut<CustomSearchController>(
      () => CustomSearchController(),
    );
  }
}
