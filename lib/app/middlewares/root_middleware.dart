import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class RootMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(route) {
    return null;
  }
}
