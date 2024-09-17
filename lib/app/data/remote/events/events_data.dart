import 'package:emarates_bd/common/class/curd.dart';

class EventsData {
  Crud crud;
  EventsData(this.crud);

  getEvents(int page) async {
    var response = await crud
        .getData("https://emiratesbd.ae/api/events?limit=5&offset=$page");
    return response.fold((l) => l, (r) => r);
  }
}
