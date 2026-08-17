import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

import 'components/prederence_list_tile.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  /// Cookie categories with their default opt-in state.
  static const Map<String, bool> _defaults = {
    "Analytics": true,
    "Personalization": false,
    "Marketing": false,
    "Social media cookies": false,
  };

  static const Map<String, String> _descriptions = {
    "Analytics":
        "Analytics cookies help us improve our application by collecting and reporting info on how you use it. They collect information in a way that does not directly identify anyone.",
    "Personalization":
        "Personalisation cookies collect information about your use of this app in order to display contect and experience that are relevant to you.",
    "Marketing":
        "Maarketing cookies collec information about your use of this and other apps to enable display ads and other marketing that is more relevant to you.",
    "Social media cookies":
        "These cookies are set by a range of social media services that we have added to the site to enable you to share our content with your friends and networks.",
  };

  late Map<String, bool> _preferences = Map.of(_defaults);

  void _toggle(String key) {
    setState(() => _preferences[key] = !(_preferences[key] ?? false));
  }

  void _reset() {
    setState(() => _preferences = Map.of(_defaults));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cookie preferences reset")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = _preferences.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cookie preferences"),
        actions: [
          TextButton(
            onPressed: _reset,
            child: const Text("Reset"),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: Column(
          children: List.generate(keys.length, (index) {
            final key = keys[index];
            return Column(
              children: [
                PreferencesListTile(
                  titleText: key,
                  subtitleTxt: _descriptions[key]!,
                  isActive: _preferences[key] ?? false,
                  press: () => _toggle(key),
                ),
                if (index != keys.length - 1)
                  const Divider(height: defaultPadding * 2),
              ],
            );
          }),
        ),
      ),
    );
  }
}
