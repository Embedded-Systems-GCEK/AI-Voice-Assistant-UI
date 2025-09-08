import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/conversation.dart';
import '../providers/app_state_provider.dart';
import '../themes/catppuccin_theme.dart';

class ConversationCard extends StatelessWidget {
  final Conversation conversation;

  const ConversationCard({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: CatppuccinColors.mauve,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Conversation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                if (conversation.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CatppuccinColors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: CatppuccinColors.green,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CatppuccinColors.surface1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: CatppuccinColors.blue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Question:',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: CatppuccinColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.question,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CatppuccinColors.surface1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 16,
                        color: CatppuccinColors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Answer:',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: CatppuccinColors.green,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      if (conversation.confidence != null)
                        Text(
                          '${(conversation.confidence! * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: CatppuccinColors.subtext1,
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.answer,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: CatppuccinColors.subtext1,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTimestamp(conversation.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CatppuccinColors.subtext1,
                      ),
                ),
                const Spacer(),
                Consumer<AppStateProvider>(
                  builder: (context, provider, child) {
                    final user = provider.users.where((u) => u.id == conversation.userId).firstOrNull;
                    if (user != null) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: CatppuccinColors.blue,
                            child: Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: CatppuccinColors.base,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              user.name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: CatppuccinColors.subtext1,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ],
        ),
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
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
