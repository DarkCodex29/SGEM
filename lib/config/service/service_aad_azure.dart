import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sgem/config/constants/config.dart';
import 'package:sgem/config/service/service_navigation.dart';
import 'package:sgem/config/service/service_secure_storage.dart';

class ServiceAADAzure {
  static final Config _config = Config(
    tenant: ConfigFile.azureTenantId,
    clientId: ConfigFile.azureClienttId,
    scope: "openid profile offline_access User.read",
    navigatorKey: ServiceNavigation.navigatorKey,
    redirectUri: ConfigFile.azureRedirectUri,
    loader: const Center(child: CircularProgressIndicator()),
    webUseRedirect: kIsWeb,
  );

  static Future<String?> login() async {
    AadOAuth oauth = AadOAuth(_config);
    final mapDataStorage = await ServiceSecureStorage.readAll();

    await oauth.login();

    final token = await oauth.getAccessToken();

    for (MapEntry<String, String> dataStorage in mapDataStorage.entries) {
      await ServiceSecureStorage.saveData(
          key: dataStorage.key, value: dataStorage.value);
    }

    return token;
  }

  static Future<String?> logouth() async {
    AadOAuth oauth = AadOAuth(_config);

    await oauth.logout();

    return await oauth.getAccessToken();
  }

  static Future<String?> refreshToken() async {
    AadOAuth oauth = AadOAuth(_config);
    final mapDataStorage = await ServiceSecureStorage.readAll();

    await oauth.refreshToken();

    final token = await oauth.getAccessToken();

    for (MapEntry<String, String> dataStorage in mapDataStorage.entries) {
      await ServiceSecureStorage.saveData(
          key: dataStorage.key, value: dataStorage.value);
    }

    return token;
  }
}
