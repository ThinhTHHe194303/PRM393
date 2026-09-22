class Settings {
  // Private constructor — cannot be called from outside this class
  Settings._internal();

  // The single instance, created only once
  static final Settings _instance = Settings._internal();

  // Factory constructor always returns the SAME instance
  factory Settings() => _instance;
}

void main() {
  final a = Settings();
  final b = Settings();

  // identical() checks if both variables point to the same memory location
  print('a and b are the same instance: ${identical(a, b)}');
}