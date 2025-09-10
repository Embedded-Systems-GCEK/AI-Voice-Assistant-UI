import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../themes/catppuccin_theme.dart';
import '../widgets/status_card.dart';
import '../widgets/sensor_data_card.dart';
import '../widgets/conversation_card.dart';
import '../widgets/user_list_card.dart';
import '../widgets/statistics_card.dart';
import 'map_screen.dart';
import 'conversation_screen.dart';
import 'users_screen.dart';
import 'ai_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Disable auto data generation that may cause layout issues
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final provider = Provider.of<AppStateProvider>(context, listen: false);
    //   provider.generateDemoData(); // Generate demo data on first load
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Voice Assistant'),
        actions: [
          Consumer<AppStateProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  if (provider.currentSystemStatus?.isOnline == true)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: CatppuccinColors.green,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: CatppuccinColors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    provider.currentSystemStatus?.isOnline == true ? 'Online' : 'Offline',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: provider.refreshAll,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _DashboardTab(),
          ConversationScreen(),
          AiChatScreen(),
          MapScreen(),
          UsersScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Conversations',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology),
            label: 'AI Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? Consumer<AppStateProvider>(
              builder: (context, provider, child) {
                return FloatingActionButton(
                  onPressed: provider.isLoading 
                      ? null 
                      : () async {
                          // Safely generate demo data without causing layout issues
                          try {
                            await provider.generateDemoData();
                          } catch (e) {
                            // Handle error gracefully
                            debugPrint('Error generating demo data: $e');
                          }
                        },
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                );
              },
            )
          : null,
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.users.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: CatppuccinColors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${provider.error}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CatppuccinColors.red,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.clearError();
                    provider.refreshAll();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.refreshAll,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s what\'s happening with your AI assistant',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CatppuccinColors.subtext1,
                      ),
                ),
                const SizedBox(height: 24),

                // Statistics cards
                const StatisticsCard(),
                const SizedBox(height: 16),

                // System status and sensor data
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StatusCard(status: provider.currentSystemStatus),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SensorDataCard(sensorData: provider.currentSensorData),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Current conversation
                if (provider.currentConversation != null)
                  ConversationCard(conversation: provider.currentConversation!),
                const SizedBox(height: 16),

                // Recent users
                const UserListCard(),
              ],
            ),
          ),
        );
      },
    );
  }
}
