// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mail _$MailFromJson(Map<String, dynamic> json) => Mail(
      id: json['id'] as String,
      senderPhone: json['senderPhone'] as String,
      recipient:
          (json['recipient'] as List<dynamic>).map((e) => e as String).toList(),
      cc: (json['cc'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      bcc: (json['bcc'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      title: json['title'] as String,
      content: json['content'] as String,
      attach: (json['attach'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      autoSave: json['autoSave'] as bool? ?? true,
      isRead: json['isRead'] as bool? ?? false,
      isStarred: json['isStarred'] as bool? ?? false,
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isTrashed: json['isTrashed'] as bool? ?? false,
      replyTo: json['replyTo'] as String?,
      forwardFrom: json['forwardFrom'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MailToJson(Mail instance) => <String, dynamic>{
      'id': instance.id,
      'senderPhone': instance.senderPhone,
      'recipient': instance.recipient,
      'cc': instance.cc,
      'bcc': instance.bcc,
      'title': instance.title,
      'content': instance.content,
      'attach': instance.attach,
      'autoSave': instance.autoSave,
      'isRead': instance.isRead,
      'isStarred': instance.isStarred,
      'labels': instance.labels,
      'isTrashed': instance.isTrashed,
      'replyTo': instance.replyTo,
      'forwardFrom': instance.forwardFrom,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };
