import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tbh, idk if this is overkill. But I think the hasOnboarded can be used in some other places of the app.
///
/// But SharedPreferences is the only thing needed to actually accomplish this
class HasOnboardedProvider with ChangeNotifier {
  bool _hasOnboarded = false;

  bool get hasOnboarded => _hasOnboarded;

  HasOnboardedProvider() {
    initLoad();
  }

  /// Generally, it should only be loaded in the constructor, but this is a special case.
  /// Because GoRouter's `redirect` callback gets called before the constructor calls initLoad. So we expose this to call it from there as well.
  Future<void> initLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _hasOnboarded = prefs.getBool('hasOnboarded') ?? false;

      final allKeys = prefs.getKeys();
      debugPrint("[Has Onboarded provider] ${allKeys}");

      notifyListeners();
    } catch (e) {
      _hasOnboarded = false;
      notifyListeners();
    }
  }

  Future<void> setHasOnboarded() async {
    try {
      _hasOnboarded = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasOnboarded', true);
      notifyListeners();
    } catch (e) {
      // Handle error appropriately
    }
  }
}

HasOnboardedProvider useHasOnboardedProvider(
  BuildContext context, {
  bool listen = true,
}) {
  return Provider.of<HasOnboardedProvider>(context, listen: listen);
}
