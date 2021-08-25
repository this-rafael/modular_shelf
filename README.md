## About

A dependency injection system for shelf, heavily based on the dependency declaration syntax of
flutter_modular and nestjs

# Usage

## Define our Usecases/Providers/Dependencies

```dart
class SumUsecase {
  const SumUsecase();

  int sum(int a, int b) => a + b;
}

class SubtractionUsecase {
  const SubtractionUsecase();

  int subtraction(int a, int b) => a - b;
}

class MathUsecase {
  final SumUsecase sumUsecase;
  final SubtractionUsecase subtractionUsecase;

  const MathUsecase(this.sumUsecase, this.subtractionUsecase);

  int sum(int a, int b) => sumUsecase.sum(a, b);

  int subtraction(int a, int b) => subtractionUsecase.subtraction(a, b);
}
```

### Define our Controllers

```dart
class TestController extends ShelfController {
  final MathUsecase mathUsecase;

  TestController(Router serverRouter, {required this.mathUsecase})
      : super(serverRouter, '/test/');

  @override
  Router get router => Router();

  int testSum(int a, int b) => mathUsecase.sum(a, b);

  int testSubtraction(int a, int b) => mathUsecase.subtraction(a, b);
}

```
### Define our Module
```dart
class TestModule extends ShelfModule {
  TestModule(Router serverRouter)
      : super(
          router: serverRouter,
          controllers: getControllers(),
          providers: getProviders(),
        );

  static Map<Type, InstanceFactory<Object>> getProviders() {
    return {
      SumUsecase: (_) => SumUsecase(),
      SubtractionUsecase: (_) => SubtractionUsecase(),
      MathUsecase: (dependencyManager) {
        final sumUsecase = dependencyManager.get<SumUsecase>();
        final subtractionUsecase = dependencyManager.get<SubtractionUsecase>();
        return MathUsecase(
          sumUsecase,
          subtractionUsecase,
        );
      }
    };
  }

  static Set<ShelfControllerFactory> getControllers() {
    return {
      (router, dependencyManager) {
        return TestController(
          router,
          mathUsecase: dependencyManager.get<MathUsecase>(),
        );
      }
    };
  }
}

```

### Usage

```dart
void main() async {
  final router = Router();

  final shelfApp = await ShelfApp({
    TestModule(router),
  }).mount();

  final module = await shelfApp.getModule<TestModule>();
  final controller = await module.getController<TestController>();

  print(controller.testSum(1, 1));
  print(controller.testSubtraction(1, 1));
}

```
