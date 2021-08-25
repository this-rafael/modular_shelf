import 'package:shelf_router/shelf_router.dart';

import 'DI/dependency_manager.dart';
import 'shelf.controller.dart';

typedef InstanceFactory<T extends Object> = T Function(
    IDependencyManager dependencyManager,
    );

typedef ShelfControllerFactory<T extends ShelfController> = T Function(
    Router router,
    IDependencyManager dependencyManager,
    );

typedef FactoryDependencyManager = IDependencyManager Function(
    Map<Type, InstanceFactory> dependencies,
    );