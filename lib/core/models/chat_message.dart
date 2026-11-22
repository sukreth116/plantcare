import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final String message;
  final bool isUser;
  final List<String>? options;
  final VoidCallback? onTap;

  ChatMessage({
    required this.text,
    required this.message,
    required this.isUser,
    this.options,
    this.onTap,
  });
}
