import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// This import will be generated after running build_runner
import 'injection.config.dart';

// This is the global GetIt instance
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // The generated function name
  preferRelativeImports: true, // Use relative imports in generated code
  asExtension: true, // Generate as extension method
)
void configureDependencies() => getIt.init();