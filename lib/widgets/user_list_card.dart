import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../themes/catppuccin_theme.dart';

class UserListCard extends StatelessWidget {
  const UserListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final recentUsers = provider.users.take(5).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: CatppuccinColors.pink,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Users',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    if (provider.users.length > 5)
                      TextButton(
                        onPressed: () {
                          // Navigate to full users list
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(color: CatppuccinColors.blue),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (recentUsers.isEmpty)
                  Text(
                    'No users found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CatppuccinColors.subtext1,
                        ),
                  )
                else
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: recentUsers.map((user) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: CatppuccinColors.blue,
                              child: user.avatarPath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.asset(
                                        user.avatarPath!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Text(
                                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: CatppuccinColors.base,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          );
                                        },
                                      ),
                                    )
                                  : Text(
                                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: CatppuccinColors.base,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (user.email != null)
                                    Text(
                                      user.email!,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: CatppuccinColors.subtext1,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  Text(
                                    'Last active: ${_formatTimestamp(user.lastInteractionAt)}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: CatppuccinColors.subtext0,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: CatppuccinColors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${user.totalInteractions}',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: CatppuccinColors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
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
