import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../components/chat_active_dot.dart';
import '../../../components/network_image_with_loader.dart';
import '../../../constants.dart';

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.sentAt,
  });

  final String text;
  final bool isMine;
  final DateTime sentAt;
}

/// Support chat.
///
/// Messages are local to this screen — there is no chat backend in this
/// project. The agent reply is a canned response so the UX is complete.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hi! I'm Ali from Shoplon support. How can I help you today?",
      isMine: false,
      sentAt: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMine: true,
        sentAt: DateTime.now(),
      ));
      _messages.add(_ChatMessage(
        text:
            "Thanks for the details! A support agent will follow up by email shortly.",
        isMine: false,
        sentAt: DateTime.now(),
      ));
    });
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Runs after the frame so the new items are laid out first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: defaultDuration,
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: const [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: NetworkImageWithLoader(
                    "https://i.imgur.com/IXnwbLk.png",
                    radius: 100,
                  ),
                ),
                ChatActiveDot(),
              ],
            ),
            const SizedBox(width: defaultPadding / 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Shoplon support",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    "Online",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: successColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(defaultPadding),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: defaultPadding),
                      padding: const EdgeInsets.all(defaultPadding),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: message.isMine
                            ? primaryColor
                            : Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadious)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              color: message.isMine
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                            ),
                          ),
                          const SizedBox(height: defaultPadding / 4),
                          Text(
                            _formatTime(message.sentAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: message.isMine
                                  ? Colors.white70
                                  : Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                      ),
                    ),
                  ),
                  const SizedBox(width: defaultPadding / 2),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: _send,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Send.svg",
                        height: 20,
                        width: 20,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
