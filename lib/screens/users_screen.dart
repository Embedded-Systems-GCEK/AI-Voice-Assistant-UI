import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/user.dart';
import '../themes/catppuccin_theme.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          final filteredUsers = provider.users.where((user) {
            return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   (user.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
          }).toList();

          return Column(
            children: [
              // Header with search
              Container(
                padding: const EdgeInsets.all(16),
                color: CatppuccinColors.surface0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: CatppuccinColors.pink,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Users',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: CatppuccinColors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${provider.users.length}',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: CatppuccinColors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: provider.refreshUsers,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search users by name or email...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Users list
              Expanded(
                child: filteredUsers.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: provider.refreshUsers,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _UserTile(
                                user: user,
                                onTap: () => _showUserDetails(user, provider),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: CatppuccinColors.overlay0,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'No users found' : 'No Users Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: CatppuccinColors.subtext1,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search query'
                : 'Add users to start tracking interactions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CatppuccinColors.subtext0,
                ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showAddUserDialog,
              icon: const Icon(Icons.person_add),
              label: const Text('Add User'),
            ),
          ],
        ],
      ),
    );
  }

  void _showUserDetails(User user, AppStateProvider provider) {
    showDialog(
      context: context,
      builder: (context) => _UserDetailDialog(
        user: user,
        provider: provider,
      ),
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddUserDialog(),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const _UserTile({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: CatppuccinColors.blue,
                child: user.avatarPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          user.avatarPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildInitials();
                          },
                        ),
                      )
                    : _buildInitials(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (user.email != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.email!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: CatppuccinColors.subtext1,
                            ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: CatppuccinColors.subtext0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${user.totalInteractions} conversations',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CatppuccinColors.subtext0,
                              ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: CatppuccinColors.subtext0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Last active: ${_formatTimestamp(user.lastInteractionAt)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CatppuccinColors.subtext0,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: CatppuccinColors.overlay0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitials() {
    return Text(
      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
      style: TextStyle(
        color: CatppuccinColors.base,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _UserDetailDialog extends StatelessWidget {
  final User user;
  final AppStateProvider provider;

  const _UserDetailDialog({
    required this.user,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CatppuccinColors.surface0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: CatppuccinColors.pink,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'User Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Avatar and basic info
            CircleAvatar(
              radius: 40,
              backgroundColor: CatppuccinColors.blue,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: CatppuccinColors.base,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (user.email != null) ...[
              const SizedBox(height: 4),
              Text(
                user.email!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CatppuccinColors.subtext1,
                    ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Conversations',
                    user.totalInteractions.toString(),
                    Icons.chat_bubble_outline,
                    CatppuccinColors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Days Active',
                    DateTime.now().difference(user.createdAt).inDays.toString(),
                    Icons.calendar_today,
                    CatppuccinColors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Timestamps
            _buildInfoRow(
              context,
              Icons.person_add,
              'Joined',
              _formatDate(user.createdAt),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.schedule,
              'Last Active',
              _formatDate(user.lastInteractionAt),
            ),
            
            const SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to user's conversations
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('View Chats'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CatppuccinColors.red,
                      foregroundColor: CatppuccinColors.base,
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CatppuccinColors.surface1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CatppuccinColors.subtext1,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: CatppuccinColors.subtext1,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CatppuccinColors.subtext1,
              ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CatppuccinColors.surface0,
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteUser(user.id!);
              Navigator.of(context).pop(); // Close confirmation
              Navigator.of(context).pop(); // Close user details
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CatppuccinColors.red,
              foregroundColor: CatppuccinColors.base,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AddUserDialog extends StatefulWidget {
  const _AddUserDialog();

  @override
  State<_AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<_AddUserDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CatppuccinColors.surface0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: CatppuccinColors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add New User',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter user name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                  hintText: 'Enter email address',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addUser,
                      child: const Text('Add User'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addUser() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        createdAt: DateTime.now(),
        lastInteractionAt: DateTime.now(),
      );
      
      provider.addUser(user);
      Navigator.of(context).pop();
    }
  }
}
