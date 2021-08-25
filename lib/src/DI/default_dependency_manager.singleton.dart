import '../shelf_modular.types.dart';
import 'dependency_manager.dart';

class DefaultDependencyManagerSingleton {
  FactoryDependencyManager factoryDependencyManager;
  static DefaultDependencyManagerSingleton instance =
  DefaultDependencyManagerSingleton(
        (dependencies) => DependencyManager(dependencies),
  );

  DefaultDependencyManagerSingleton(this.factoryDependencyManager);

  static void setDependencyManager(
      FactoryDependencyManager factoryDependencyManager,
      ) {
    instance.factoryDependencyManager = factoryDependencyManager;
  }
}