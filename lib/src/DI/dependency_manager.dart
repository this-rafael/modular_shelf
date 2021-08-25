import '../shelf_modular.types.dart';

abstract class IDependencyManager {
  T get<T extends Object>();
}
class DependencyManager implements IDependencyManager {
  final Map<Type, Object> dependencies;
  final Map<Type, InstanceFactory> factoryDependencies;

  DependencyManager(this.factoryDependencies) : dependencies = <Type, Object>{};

  @override
  T get<T extends Object>() {
    final dependency = dependencies[T];

    if (dependency != null) {
      return dependency as T;
    } else {
      final factoryDependency = factoryDependencies[T];
      if (factoryDependency != null) {
        final dependency2 = (factoryDependency(this)) as T;
        dependencies.addAll({dependency2.runtimeType: dependency2});
        return dependency2;
      } else {
        throw Exception();
      }
    }
  }
}