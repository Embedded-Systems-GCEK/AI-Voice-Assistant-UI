import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/conversation.dart';
import '../themes/catppuccin_theme.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedUserId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          final conversations = _selectedUserId != null
              ? provider.conversations.where((c) => c.userId == _selectedUserId).toList()
              : provider.conversations;

          return Column(
            children: [
              // Header with filters
              Container(
                padding: const EdgeInsets.all(16),
                color: CatppuccinColors.surface0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: CatppuccinColors.mauve,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Conversations',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: provider.refreshConversations,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // User filter dropdown
                    Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 20,
                          color: CatppuccinColors.subtext1,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<int?>(
                            value: _selectedUserId,
                            decoration: InputDecoration(
                              labelText: 'Filter by user',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('All users'),
                              ),
                              ...provider.users.map((user) => DropdownMenuItem<int?>(
                                value: user.id,
                                child: Text(user.name),
                              )),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedUserId = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Conversations list
              Expanded(
                child: conversations.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: provider.refreshConversations,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            final conversation = conversations[index];
                            final user = provider.users
                                .where((u) => u.id == conversation.userId)
                                .firstOrNull;
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _ConversationTile(
                                conversation: conversation,
                                user: user,
                                onTap: () => _showConversationDetails(conversation, user),
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: CatppuccinColors.overlay0,
          ),
          const SizedBox(height: 16),
          Text(
            'No Conversations Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: CatppuccinColors.subtext1,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with the AI assistant',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CatppuccinColors.subtext0,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showConversationDetails(Conversation conversation, dynamic user) {
    showDialog(
      context: context,
      builder: (context) => _ConversationDetailDialog(
        conversation: conversation,
        user: user,
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final dynamic user;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (user != null) ...[
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: CatppuccinColors.blue,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: CatppuccinColors.base,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: Text(
                        'Unknown User',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: CatppuccinColors.subtext1,
                            ),
                      ),
                    ),
                  Text(
                    _formatTimestamp(conversation.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CatppuccinColors.subtext0,
                        ),
                  ),
                  if (conversation.isActive) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: CatppuccinColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              
              // Question
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CatppuccinColors.surface1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: CatppuccinColors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        conversation.question,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // Answer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CatppuccinColors.surface1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.psychology,
                      size: 16,
                      color: CatppuccinColors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        conversation.answer,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (conversation.confidence != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(conversation.confidence!).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(conversation.confidence! * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: _getConfidenceColor(conversation.confidence!),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return CatppuccinColors.green;
    if (confidence >= 0.6) return CatppuccinColors.yellow;
    return CatppuccinColors.red;
  }
}

class _ConversationDetailDialog extends StatelessWidget {
  final Conversation conversation;
  final dynamic user;

  const _ConversationDetailDialog({
    required this.conversation,
    required this.user,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.chat_bubble,
                  color: CatppuccinColors.mauve,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Conversation Details',
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
            const SizedBox(height: 20),
            
            // User info
            if (user != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: CatppuccinColors.blue,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: CatppuccinColors.base,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      if (user.email != null)
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CatppuccinColors.subtext1,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            
            // Question
            Text(
              'Question:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: CatppuccinColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CatppuccinColors.surface1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                conversation.question,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            
            // Answer
            Row(
              children: [
                Text(
                  'Answer:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: CatppuccinColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                if (conversation.confidence != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(conversation.confidence!).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Confidence: ${(conversation.confidence! * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _getConfidenceColor(conversation.confidence!),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CatppuccinColors.surface1,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                conversation.answer,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            
            // Additional info
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: CatppuccinColors.subtext1,
                ),
                const SizedBox(width: 6),
                Text(
                  'Timestamp: ${conversation.timestamp.toLocal().toString().substring(0, 19)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CatppuccinColors.subtext1,
                      ),
                ),
              ],
            ),
            if (conversation.context != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: CatppuccinColors.subtext1,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Context: ${conversation.context}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: CatppuccinColors.subtext1,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return CatppuccinColors.green;
    if (confidence >= 0.6) return CatppuccinColors.yellow;
    return CatppuccinColors.red;
  }
}
