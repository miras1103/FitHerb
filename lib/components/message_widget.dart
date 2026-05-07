import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers.dart';
import '../models/message.dart';

class MessageWidget extends ConsumerWidget {
  const MessageWidget(
    this.message, {
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userDao = ref.watch(userDaoProvider);
    final myMessage = message.email == userDao.email();

    return Column(
      crossAxisAlignment:
          myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!myMessage)
              Text(
                message.email,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                ),
              )
            else
              const Text(''),
            Text(
              ' ${DateFormat.yMd().format(message.date)} '
              '${DateFormat.Hm().format(message.date)}',
              style: TextStyle(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        FractionallySizedBox(
          alignment: myMessage ? Alignment.topRight : Alignment.topLeft,
          widthFactor: 0.7,
          child: Card(
            color: myMessage
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message.text,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
