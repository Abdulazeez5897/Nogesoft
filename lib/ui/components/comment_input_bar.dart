
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String? profilePicUrl;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.profilePicUrl,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> with SingleTickerProviderStateMixin {
  final List<String> _emojis = ['❤️', '🙏', '🔥', '👏', '😢', '😍', '😐', '😂'];
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _focusNode.requestFocus();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _insertEmoji(String emoji) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final newText = text.replaceRange(selection.start, selection.end, emoji);

    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(offset: selection.start + emoji.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SlideTransition(
          position: _offsetAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Wrap(
              spacing: 8,
              children: _emojis.map((emoji) {
                return GestureDetector(
                  onTap: () => _insertEmoji(emoji),
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: widget.profilePicUrl != null && widget.profilePicUrl!.isNotEmpty
                    ? NetworkImage(widget.profilePicUrl!)
                    : null,
                child: (widget.profilePicUrl == null || widget.profilePicUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 10),

              // Input field
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    decoration: const InputDecoration(
                      hintText: "What do you think of this?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // Send icon
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.blue),
                onPressed: widget.onSend,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
