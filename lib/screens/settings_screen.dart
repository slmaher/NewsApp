import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 6),
            SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: const Text('Enable a dark app theme'),
              value: isDarkMode,
              onChanged: onThemeChanged,
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
            const Divider(height: 1),
            const ListTile(
              leading: Icon(Icons.info_outline_rounded),
              title: Text('About'),
              subtitle: Text('News App - Mobile Computing Project'),
            ),
          ],
        ),
      ),
    );
  }
}
