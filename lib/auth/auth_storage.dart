import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  AuthStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _userNameKey = 'user_name';
  static const String _displayNameKey = 'display_name';

  /// Save the authenticated user's session.
  static Future<void> saveSession({
    required String accessToken,
    String? userName,
    String? displayName,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);

    if (userName != null && userName.isNotEmpty) {
      await _storage.write(key: _userNameKey, value: userName);
    }

    if (displayName != null && displayName.isNotEmpty) {
      await _storage.write(key: _displayNameKey, value: displayName);
    }
  }

  /// Returns the JWT access token.
  static Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  /// Returns the logged-in username.
  static Future<String?> getUserName() async {
    return _storage.read(key: _userNameKey);
  }

  /// Returns the logged-in user's display name.
  static Future<String?> getDisplayName() async {
    return _storage.read(key: _displayNameKey);
  }

  /// Returns true when a token exists.
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();

    return token != null && token.isNotEmpty;
  }

  /// Clears the complete authenticated session.
  static Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);

    await _storage.delete(key: _userNameKey);

    await _storage.delete(key: _displayNameKey);
  }
}
