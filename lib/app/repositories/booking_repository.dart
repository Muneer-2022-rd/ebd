import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/coupon_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_provider.dart';

class BookingRepository {
   LaravelApiClient _laravelApiClient = LaravelApiClient();

  BookingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Booking>> all(String statusId, {required int page}) {
    return _laravelApiClient.getBookings(statusId, page);
  }

  Future<List<BookingStatus>> getStatuses() {
    return _laravelApiClient.getBookingStatuses();
  }

  Future<Booking> get(String bookingId) {
    return _laravelApiClient.getBooking(bookingId);
  }

  Future<Booking> add(Booking booking) {
    return _laravelApiClient.addBooking(booking);
  }

  Future<Booking> update(Booking booking) {
    return _laravelApiClient.updateBooking(booking);
  }

  Future<Coupon> coupon(Booking booking) {
    return _laravelApiClient.validateCoupon(booking);
  }

  Future<Review> addReview(Review review) {
    return _laravelApiClient.addReview(review);
  }
  Future<Review> addReviewwithoutbooking(double rate, String review , String user_id, String service_id) {
    return _laravelApiClient.addReviewWithoutBooking(rate,review,user_id,service_id);
  }
  Future<bool> addReviewProviderwithoutbooking(double rate, String review , String apiToken, String providerId) {
    return _laravelApiClient.addReviewEproviderWithoutBooking(rate,review,apiToken,providerId);
  }
}
