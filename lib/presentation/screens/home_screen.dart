import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/call_bloc.dart';
import '../bloc/call_event.dart';
import '../bloc/call_state.dart';
import '../widgets/status_card.dart';
import '../widgets/settings_tile.dart';
import '../widgets/frequency_slider.dart';
import '../widgets/logs_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Rejecter Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CallBloc>().add(LoadSettingsAndLogs()),
          )
        ],
      ),
      body: BlocBuilder<CallBloc, CallState>(
        builder: (context, state) {
          if (state is CallLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CallLoaded) {
            final settings = state.settings;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusCard(
                    isActive: settings.isDefaultApp,
                    onRequestSetup: () => context.read<CallBloc>().add(RequestDefaultAppAction()),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(context, 'General Settings'),
                  SettingsTile(
                    title: 'Enable Call Blocking',
                    subtitle: 'Automatically screen and reject calls',
                    value: settings.blockEnabled,
                    onChanged: (val) => context.read<CallBloc>().add(UpdateSetting('blockEnabled', val)),
                    icon: Icons.block,
                  ),
                  const SizedBox(height: 10),
                  _buildSectionHeader(context, 'Filtering Modes'),
                  SettingsTile(
                    title: 'Whitelist Mode',
                    subtitle: 'Allow only saved contacts',
                    value: settings.whitelistMode,
                    onChanged: (val) => context.read<CallBloc>().add(UpdateSetting('whitelistMode', val)),
                    icon: Icons.contact_phone,
                  ),
                  SettingsTile(
                    title: 'Focus Mode',
                    subtitle: 'Allow only starred contacts',
                    value: settings.focusMode,
                    onChanged: (val) => context.read<CallBloc>().add(UpdateSetting('focusMode', val)),
                    icon: Icons.star,
                  ),
                  const SizedBox(height: 10),
                  _buildSectionHeader(context, 'Spam Frequency Protection'),
                  FrequencySlider(
                    maxCalls: settings.maxCalls,
                    timeWindow: settings.timeWindow,
                    onMaxCallsChanged: (val) => context.read<CallBloc>().add(UpdateSetting('maxCalls', val)),
                    onTimeWindowChanged: (val) => context.read<CallBloc>().add(UpdateSetting('timeWindow', val)),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(context, 'Blocked Call Logs'),
                  LogsList(logs: state.logs),
                ],
              ),
            );
          }

          if (state is CallError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 12,
        ),
      ),
    );
  }
}
