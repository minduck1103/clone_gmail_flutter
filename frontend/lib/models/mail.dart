import 'package:json_annotation/json_annotation.dart';

part 'mail.g.dart';

@JsonSerializable()
class Mail {
  final String id;
  final String senderPhone;
  final List<String> recipient;
  final List<String> cc;
  final List<String> bcc;
  final String title;
  final String content;
  final List<String> attach;
  final bool autoSave;
  final bool isRead;
  final bool isStarred;
  final List<String> labels;
  final bool isTrashed;
  final String? replyTo;
  final String? forwardFrom;
  final String createdBy;
  final DateTime createdAt;

  Mail({
    required this.id,
    required this.senderPhone,
    required this.recipient,
    this.cc = const [],
    this.bcc = const [],
    required this.title,
    required this.content,
    this.attach = const [],
    this.autoSave = true,
    this.isRead = false,
    this.isStarred = false,
    this.labels = const [],
    this.isTrashed = false,
    this.replyTo,
    this.forwardFrom,
    required this.createdBy,
    required this.createdAt,
  });

  factory Mail.fromJson(Map<String, dynamic> json) => Mail(
        id: json['_id'] ?? '',
        senderPhone: json['senderPhone'] ?? '',
        recipient: List<String>.from(json['recipient'] ?? []),
        cc: List<String>.from(json['cc'] ?? []),
        bcc: List<String>.from(json['bcc'] ?? []),
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        attach: List<String>.from(json['attach'] ?? []),
        autoSave: json['autoSave'] ?? true,
        isRead: json['isRead'] ?? false,
        isStarred: json['isStarred'] ?? false,
        labels: List<String>.from(json['labels'] ?? []),
        isTrashed: json['isTrashed'] ?? false,
        replyTo: json['replyTo']?['_id'],
        forwardFrom: json['forwardFrom']?['_id'],
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
  Map<String, dynamic> toJson() => _$MailToJson(this);

  Mail copyWith({
    String? id,
    String? senderPhone,
    List<String>? recipient,
    List<String>? cc,
    List<String>? bcc,
    String? title,
    String? content,
    List<String>? attach,
    bool? autoSave,
    bool? isRead,
    bool? isStarred,
    List<String>? labels,
    bool? isTrashed,
    String? replyTo,
    String? forwardFrom,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Mail(
      id: id ?? this.id,
      senderPhone: senderPhone ?? this.senderPhone,
      recipient: recipient ?? this.recipient,
      cc: cc ?? this.cc,
      bcc: bcc ?? this.bcc,
      title: title ?? this.title,
      content: content ?? this.content,
      attach: attach ?? this.attach,
      autoSave: autoSave ?? this.autoSave,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
      labels: labels ?? this.labels,
      isTrashed: isTrashed ?? this.isTrashed,
      replyTo: replyTo ?? this.replyTo,
      forwardFrom: forwardFrom ?? this.forwardFrom,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
