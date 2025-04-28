// class SupportTicketBody {
//   String? _type;
//   String? _subject;
//   String? _description;
//   String? _priority;
//   String? _orderId;

//   SupportTicketBody(String type, String subject, String description, String priority, String? orderId) {
//     _type = type;
//     _subject = subject;
//     _description = description;
//     _priority = priority;
//     _orderId = orderId;
//   }

//   String? get type => _type;
//   String? get subject => _subject;
//   String? get description => _description;
//   String? get priority => _priority;
//   String? get orderId => _orderId;

//   SupportTicketBody.fromJson(Map<String, dynamic> json) {
//     _type = json['type'];
//     _subject = json['subject'];
//     _description = json['description'];
//     _priority = json['priority'];
//     _orderId = json['order_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = _type;
//     data['subject'] = _subject;
//     data['description'] = _description;
//     data['priority'] = _priority;
//     data['order_id'] = _orderId;
//     return data;
//   }
// }

class SupportTicketBody {
  final String type;
  final String subject;
  final String description;
  final String priority;
  final String? orderId;

  SupportTicketBody({
    required this.type,
    required this.subject,
    required this.description,
    required this.priority,
    this.orderId,
  });

  factory SupportTicketBody.fromJson(Map<String, dynamic> json) {
    return SupportTicketBody(
      type: json['type'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      orderId: json['order_id'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'subject': subject,
      'description': description,
      'priority': priority,
      'order_id': orderId,
    };
  }
}
