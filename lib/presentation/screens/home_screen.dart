import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/call_bloc.dart';
import '../bloc/call_event.dart';
import '../bloc/call_state.dart';
import '../widgets/status_card.dart';
import '../widgets/settings_tile.dart';
import '../widgets/frequency_slider.dart';

import 'logs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<CallBloc>().add(LoadSettingsAndLogs());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'Call Shield Setup' : 'Blocked Call Logs',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildSettingsView(context),
          const LogsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu),
            label: 'Blocked History',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsView(BuildContext context) {
    return BlocBuilder<CallBloc, CallState>(
      builder: (context, state) {
        if (state is CallLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CallLoaded) {
          final settings = state.settings;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusCard(
                  isActive: settings.isDefaultApp,
                  onRequestSetup: () => context.read<CallBloc>().add(RequestDefaultAppAction()),
                ),
                const SizedBox(height: 24),
                _buildSectionCard(
                  title: 'Core Blocking Mode',
                  icon: Icons.shield,
                  children: [
                    SettingsTile(
                      title: 'Enable Call Screening',
                      subtitle: 'Master toggle for automatic screening',
                      value: settings.blockEnabled,
                      onChanged: (val) => context.read<CallBloc>().add(UpdateSetting('blockEnabled', val)),
                      icon: Icons.block,
                    ),
                    SettingsTile(
                      title: 'Extreme Block Mode',
                      subtitle: 'Block ALL calls regardless of contact status',
                      value: settings.blockAll,
                      onChanged: (val) => context.read<CallBloc>().add(UpdateSetting('blockAll', val)),
                      icon: Icons.dangerous,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Filtering Preferences',
                  icon: Icons.filter_alt,
                  children: [
                    SettingsTile(
                      title: 'Whitelist Only',
                      subtitle: 'Allow only saved contacts',
                      value: settings.whitelistMode,
                      onChanged: (val) => context.read<CallBloc>().add(UpdateSetting('whitelistMode', val)),
                      icon: Icons.contact_phone,
                    ),
                    SettingsTile(
                      title: 'Focus Favorites',
                      subtitle: 'Allow only starred contacts',
                      value: settings.focusMode,
                      onChanged: (val) => context.read<CallBloc>().add(UpdateSetting('focusMode', val)),
                      icon: Icons.star,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Frequency Limit',
                  icon: Icons.av_timer,
                  padding: const EdgeInsets.all(16),
                  children: [
                    FrequencySlider(
                      maxCalls: settings.maxCalls,
                      timeWindow: settings.timeWindow,
                      onMaxCallsChanged: (val) => context.read<CallBloc>().add(UpdateSetting('maxCalls', val)),
                      onTimeWindowChanged: (val) => context.read<CallBloc>().add(UpdateSetting('timeWindow', val)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }

        if (state is CallError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    EdgeInsets? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 16, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
