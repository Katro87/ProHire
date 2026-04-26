import 'package:cloud_firestore/cloud_firestore.dart';

class RequestItem {
  final String id;
  final String senderId;
  final String receiverId;
  final String description;
  final String requirements;
  final String duration;
  final double hourlyPay;
  final String status; // pending, accepted, rejected
  final DateTime createdAt;
  final Map<String, dynamic>? senderSnapshot;
  final Map<String, dynamic>? receiverSnapshot;

  const RequestItem({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.description,
    required this.requirements,
    required this.duration,
    required this.hourlyPay,
    required this.status,
    required this.createdAt,
    required this.senderSnapshot,
    required this.receiverSnapshot,
  });

  static RequestItem fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return RequestItem(
      id: doc.id,
      senderId: data['senderId'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      description: data['description'] as String? ?? '',
      requirements: data['requirements'] as String? ?? '',
      duration: data['duration'] as String? ?? '',
      hourlyPay: (data['hourlyPay'] as num?)?.toDouble() ?? 0,
      status: data['status'] as String? ?? 'pending',
      createdAt: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      senderSnapshot: data['senderSnapshot'] as Map<String, dynamic>?,
      receiverSnapshot: data['receiverSnapshot'] as Map<String, dynamic>?,
    );
  }
}
