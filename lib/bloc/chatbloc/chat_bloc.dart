// // chat_bloc.dart
// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'chat_event.dart';
// import 'chat_state.dart';

// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   final CollectionReference messageCollection =
//       FirebaseFirestore.instance.collection("messages");

//   ChatBloc() : super(ChatInitial()) {
//     on<SendMessageEvent>(_onSendMessage);
//   }

//   Future<void> _onSendMessage(
//       SendMessageEvent event, Emitter<ChatState> emit) async {
//     try {
//       await messageCollection.add({
//         "message": event.message,
//         "timestamp": FieldValue.serverTimestamp(),
//         "isMe": true,
//       });
//     } catch (e) {
//       emit(ChatError(e.toString()));
//     }
//   }

//   // Stream for listening to real-time messages
//   Stream<QuerySnapshot> get messagesStream {
//     return messageCollection.orderBy("timestamp", descending: true).snapshots();
//   }
// }

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection("messages");

  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendImageEvent>(_onSendImage);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      await messageCollection.add({
        "message": event.message,
        "timestamp": FieldValue.serverTimestamp(),
        "isImage": false,
        "isMe": true,
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendImage(
      SendImageEvent event, Emitter<ChatState> emit) async {
    try {
      await messageCollection.add({
        "message": event.imagePath,
        "timestamp": FieldValue.serverTimestamp(),
        "isImage": true,
        "isMe": true,
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Stream<QuerySnapshot> get messagesStream {
    return messageCollection.orderBy("timestamp", descending: true).snapshots();
  }
}
