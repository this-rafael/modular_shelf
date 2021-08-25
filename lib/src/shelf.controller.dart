import 'dart:async';

import 'package:shelf_router/shelf_router.dart';

abstract class ShelfController {
  final Router serverRouter;
  final String route;

  const ShelfController(this.serverRouter, this.route);

  Router get router;


  FutureOr<void> mount() {
    serverRouter.mount(route, router);
  }
}