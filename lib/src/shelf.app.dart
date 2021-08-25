import 'dart:async';

import 'DI/shelf_module.dart';

abstract class IShelfApp {
  FutureOr<IShelfApp> mount();
  FutureOr<T> getModule<T extends IShelfModule>();
}

class ShelfApp implements IShelfApp {
  final Set<IShelfModule> modules;

  const ShelfApp(this.modules);

  @override
  FutureOr<IShelfApp> mount() async {
    for (var module in modules) {
      await module.mount();
    }

    return this;
  }

  @override
  FutureOr<T> getModule<T extends IShelfModule>() {
    return modules.singleWhere((element) => element.runtimeType == T) as T;
  }
}