import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/request_model.dart';

class RequestService {
  RequestService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> createRequest({
    required String senderId,
    required String receiverId,
    required String description,
    required String requirements,
    required String duration,
    required double hourlyPay,
    required Map<String, dynamic> senderSnapshot,
    required Map<String, dynamic> receiverSnapshot,
  }) async {
    await _firestore.collection('requests').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'participants': [senderId, receiverId],
      'description': description,
      'requirements': requirements,
      'duration': duration,
      'hourlyPay': hourlyPay,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
      'senderSnapshot': senderSnapshot,
      'receiverSnapshot': receiverSnapshot,
    });
  }

  Stream<List<RequestItem>> watchRequests(String uid) {
    return _firestore
        .collection('requests')
        .where('participants', arrayContains: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map(RequestItem.fromDoc).toList());
  }

  Stream<List<RequestItem>> watchRequestsForReceiver(String receiverId) {
    return _firestore
        .collection('requests')
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(RequestItem.fromDoc).toList());
  }

  Future<void> updateStatus(String requestId, String status) async {
    await _firestore.collection('requests').doc(requestId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
