import 'package:chatapp/Models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatservices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getuserStream() {
    return _firestore.collection("users").snapshots().map((snapshots) {
      return snapshots.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendmsg(String receiverId, message) async {
    final String currentUserid = _auth.currentUser!.uid;
    final String currentUseremail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
        senderId: currentUserid,
        senderEmail: currentUseremail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);
    List<String> ids = [currentUserid, receiverId];
    ids.sort();
    String chatroomId = ids.join('_');
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, otheruserId) {
    List<String> ids = [userId, otheruserId];
    ids.sort();
    String chatroomId = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
