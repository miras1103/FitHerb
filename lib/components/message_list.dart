import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/message.dart';
import 'message_widget.dart';

class MessageList extends ConsumerStatefulWidget {
  const MessageList({super.key});

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final messageDao = ref.read(messageDaoProvider);
      messageDao.sendMessage(_messageController.text.trim());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final data = ref.watch(messageListProvider);
                return data.when(
                  loading: () => const Center(
                    child: LinearProgressIndicator(),
                  ),
                  data: (List<Message> messages) => ListView(
                    controller: _scrollController,
                    reverse: true,
                    children: [
                      for (final message in messages)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0,
                              4.0),
                          child: MessageWidget(message),
                        ),
                    ],
                  ),
                  error: (error, stackTrace) {
                    return Center(child: Text('$error'));
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText:
                    'Type a message'),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
