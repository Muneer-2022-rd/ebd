import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emarates_bd/app/data/remote/events/events_data.dart';
import 'package:emarates_bd/app/models/event_model.dart';
import 'package:emarates_bd/app/repositories/event_repository.dart';
import 'package:emarates_bd/common/Functions/handeldata.dart';
import 'package:emarates_bd/common/Functions/stutsrequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../common/ui.dart';

class EventsController extends GetxController {
  late RefreshController refreshController;
  EventsData eventsData = EventsData(Get.find());
  StatusRequest statusRequest = StatusRequest.non;
  int currentPage = 1;
  int totalPages = 0;
  List eventsList = [];

  late EventRepository _eventRepository;

  final events = <Event>[].obs;
  // final bookingStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;

  ScrollController scrollController = ScrollController();

  EventsController() {
    _eventRepository = new EventRepository();
  }

  @override
  Future<void> onInit() async {
    refreshController = RefreshController(initialRefresh: true);
    super.onInit();
  }

  Future refreshEvents({bool showMessage = false, String? statusId}) async {
    // changeTab(statusId);
    // if (showMessage) {
    await getEvents(isRefresh: true);
    // }
  }

  void initScrollController() {
    scrollController = ScrollController();
    refreshController = RefreshController(initialRefresh: true);
  }

//
  getEvents({bool isRefresh = false}) async {
    print("run");
    statusRequest = StatusRequest.loading;
    if (isRefresh) {
      print("refresh");
      refreshController.resetNoData();
      currentPage = 1;
      update();
    } else {
      if (currentPage > totalPages) {
        refreshController.loadNoData();
      }
    }
    var response = await eventsData.getEvents(currentPage);
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response["success"] == true) {
        if (isRefresh) {
          eventsList = response["data"];
        } else {
          eventsList.addAll(response["data"]);
        }
        currentPage = currentPage + 1;
        totalPages = response["total"];
        print("current Page : $currentPage");
        print("total pages : $totalPages");
        print("Providers Cites : $eventsList");
        update();
        return true;
      } else {
        statusRequest = StatusRequest.failure;
        print("false");
        return false;
      }
    }
    update();
  }

  //
  // Future getEvents() async {
  //   try {
  //
  //     events.assignAll(await _eventRepository.getAllEvents());
  //     isLoading.value = false;
  //   } catch (e) {
  //     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  void changeTab(String statusId) async {
    this.events.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }

  Future loadBookingsOfStatus({String? statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Event> _events = [];

      isDone.value = true;
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> cancelBookingService(Booking booking) async {
  //   try {
  //     if (booking.status.order < Get.find<GlobalService>().global.value.onTheWay) {
  //       final _status = getStatusByOrder(Get.find<GlobalService>().global.value.failed);
  //       final _booking = new Booking(id: booking.id, cancel: true, status: _status);
  //       await _bookingsRepository.update(_booking);
  //       bookings.removeWhere((element) => element.id == booking.id);
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
}
