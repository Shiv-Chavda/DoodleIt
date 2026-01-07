import 'package:flutter_dotenv/flutter_dotenv.dart';

// Server Configuration
// Reads from .env file for better security and environment management
class ServerConfig {
  // Get server URL from environment variable
  // Falls back to localhost if not set
  static String get serverUrl {
    return dotenv.env['SERVER_URL'] ?? 'http://localhost:3000';
  }
  
  // For debugging
  static void printConfig() {
    print('🔧 Server URL: $serverUrl');
  }
}
