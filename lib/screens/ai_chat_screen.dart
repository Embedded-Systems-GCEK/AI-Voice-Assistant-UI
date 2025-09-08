import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/app_state_provider.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<ChatMessage> _messages = [];
  List<ExampleQuestion> _exampleQuestions = [];
  bool _isLoading = false;
  bool _isLoadingExamples = false;
  String? _selectedCategory;
  Set<String> _categories = {};

  @override
  void initState() {
    super.initState();
    _loadExampleQuestions();
    _checkAssistantStatus();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadExampleQuestions() async {
    setState(() => _isLoadingExamples = true);
    
    try {
      final response = await _apiService.getExampleQuestions();
      final questions = (response['questions'] as List)
          .map((q) => ExampleQuestion.fromJson(q))
          .toList();
      
      final categories = (response['categories'] as List<dynamic>?)
          ?.cast<String>().toSet() ?? <String>{};

      setState(() {
        _exampleQuestions = questions;
        _categories = categories;
        _isLoadingExamples = false;
      });
    } catch (e) {
      setState(() => _isLoadingExamples = false);
      _showErrorSnackBar('Failed to load example questions: $e');
    }
  }

  Future<void> _checkAssistantStatus() async {
    try {
      final status = await _apiService.getAssistantStatus();
      if (mounted) {
        final provider = Provider.of<AppStateProvider>(context, listen: false);
        // You can update the app state with assistant status if needed
        
        if (status['available'] == true) {
          _addMessage(
            'Assistant', 
            'Hi! I\'m ${status['name'] ?? 'ARIA'}, your AI assistant. How can I help you today?',
            isUser: false,
          );
        }
      }
    } catch (e) {
      _addMessage(
        'System', 
        'Assistant is currently offline. You can still ask questions and I\'ll do my best to help!',
        isUser: false,
      );
    }
  }

  void _addMessage(String sender, String message, {required bool isUser}) {
    setState(() {
      _messages.add(ChatMessage(
        sender: sender,
        message: message,
        timestamp: DateTime.now(),
        isUser: isUser,
      ));
    });
    
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _addMessage('You', message, isUser: true);
    setState(() => _isLoading = true);

    try {
      // Get current user from provider (if available)
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      // Assuming you have a current user in your app state
      
      final response = await _apiService.askAssistant(
        question: message,
        // userId: provider.currentUser?.id, // Uncomment if you have user management
      );

      final assistantResponse = AssistantResponse.fromJson(response);
      _addMessage('Assistant', assistantResponse.response, isUser: false);

    } catch (e) {
      _addMessage('System', 'Sorry, I encountered an error: $e', isUser: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _askExampleQuestion(ExampleQuestion question) {
    _messageController.text = question.question;
    _sendMessage(question.question);
    _messageController.clear();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<ExampleQuestion> get _filteredQuestions {
    if (_selectedCategory == null) return _exampleQuestions;
    return _exampleQuestions.where((q) => q.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExampleQuestions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Example Questions Section
          if (_exampleQuestions.isNotEmpty) ...[
            Container(
              constraints: const BoxConstraints(maxHeight: 160),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Example Questions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_categories.isNotEmpty)
                        DropdownButton<String>(
                          value: _selectedCategory,
                          hint: const Text('All Categories'),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('All Categories'),
                            ),
                            ..._categories.map((category) =>
                              DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedCategory = value);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: _isLoadingExamples
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _filteredQuestions.length,
                              itemBuilder: (context, index) {
                                final question = _filteredQuestions[index];
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 8),
                                  child: Card(
                                    child: InkWell(
                                      onTap: () => _askExampleQuestion(question),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                question.category,
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Flexible(
                                              child: Text(
                                                question.question,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              question.description,
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.grey[600],
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
          
          // Chat Messages
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'Start a conversation by typing a message or selecting an example question!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatBubble(message: message);
                    },
                  ),
          ),
          
          // Loading Indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Assistant is thinking...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          
          // Input Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 100),
                      child: TextField(
                        controller: _messageController,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                        onSubmitted: (value) {
                          _sendMessage(value);
                          _messageController.clear();
                        },
                        enabled: !_isLoading,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _isLoading
                          ? null
                          : () {
                              _sendMessage(_messageController.text);
                              _messageController.clear();
                            },
                      child: const Icon(Icons.send, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isUser;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isUser,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.smart_toy, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: message.isUser 
                        ? null 
                        : Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : null,
                      fontSize: 14,
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${message.sender} • ${_formatTime(message.timestamp)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 14, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
