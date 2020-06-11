import 'dart:async';
import 'package:flutter_stripe_payments/data/network/preferences/preference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  //Singleton instance
  PreferenceManager._internal();

  static PreferenceManager instance = new PreferenceManager._internal();
  static SharedPreferences _prefs;

  factory PreferenceManager() {
    return instance;
  }

  Future<void> clearAll() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
  }

  /// ------------------( IS LOGIN )------------------
  Future<bool> getIsLogin() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.getBool(PreferenceConstants.IS_LOGIN);
  }

  Future<void> setIsLogin(bool isLogin) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(PreferenceConstants.IS_LOGIN, isLogin);
  }

  Future<String> getSubDomain() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.getString(PreferenceConstants.SUB_DOMAIN);
  }

  Future<void> setSubDomain(String subDomain) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PreferenceConstants.SUB_DOMAIN, subDomain);
  }

  Future<String> getUserId() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.getString(PreferenceConstants.USER_ID);
  }

  Future<void> setUserId(String subDomain) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PreferenceConstants.USER_ID, subDomain);
  }

  Future<String> getSecurityToken() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.getString(PreferenceConstants.SECURITY_TOKEN);
  }

  Future<void> setSecurityToken(String securityToken) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PreferenceConstants.SECURITY_TOKEN, securityToken);
  }

  ///DEVICE TOKEN
  Future<String> getDeviceToken() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return _prefs.get(PreferenceConstants.DEVICE_TOKEN) ?? "";
  }

  Future<void> setDeviceToken(String deviceToken) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PreferenceConstants.DEVICE_TOKEN, deviceToken);
  }

}
