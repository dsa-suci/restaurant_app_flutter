import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/theme/theme_provider.dart';
import 'package:restaurant_app/provider/reminder/reminder_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Ganti tema aplikasi'),
            value: themeProvider.isDarkTheme,
            onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Daily Reminder'),
            subtitle: const Text('Ingatkan saya untuk makan siang pukul 11:00'),
            value: reminderProvider.isReminderActive,
            onChanged: (value) {
              reminderProvider.toggleReminder(value);
            },
          ),
        ],
      ),
    );
  }
}
