import 'dart:async';

import 'package:shelf_router/shelf_router.dart';

import '../shelf.controller.dart';
import '../shelf_modular.types.dart';
import 'default_dependency_manager.singleton.dart';
import 'dependency_manager.dart';

abstract class IShelfModule {
  FutureOr<void> mount();

  FutureOr<T> getController<T>();

  FutureOr<IDependencyManager> getDependencyManager();
}

abstract class ShelfModule implements IShelfModule {
  late final Set<ShelfController> controllers;
  late final IDependencyManager dependencyManager;
  final Router router;

  ShelfModule({
    required this.router,
    required Map<Type, InstanceFactory> providers,
    required Set<ShelfControllerFactory> controllers,
  }) {
    final dependencyManager = DefaultDependencyManagerSingleton.instance
        .factoryDependencyManager(providers);

    this.dependencyManager = dependencyManager;
    this.controllers =
        controllers.map((e) => e(router, dependencyManager)).toSet();
  }

  @override
  FutureOr<void> mount() async {
    for (var controller in controllers) {
      await controller.mount();
    }
  }

  @override
  FutureOr<T> getController<T>() async {
    return controllers.singleWhere((element) => element.runtimeType == T) as T;
  }

  @override
  FutureOr<IDependencyManager> getDependencyManager() async {
    return dependencyManager;
  }
}
