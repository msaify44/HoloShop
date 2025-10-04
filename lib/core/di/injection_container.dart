import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Initialize all dependencies for the application
Future<void> initializeDependencies() async {
  // Initialize core dependencies
  await _initializeCore();
  
  // Initialize feature modules
  await _initializeFeatures();
}

/// Initialize core dependencies
Future<void> _initializeCore() async {
  // Core dependencies will be added here as needed
}

/// Initialize feature module dependencies
Future<void> _initializeFeatures() async {
  // Add feature modules here as they are created
  // await initializeProfileDependencies(getIt);
  // await initializeCartDependencies(getIt);
}
