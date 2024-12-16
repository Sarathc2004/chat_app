// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:watsappchatscreen/bloc/chatbloc/chat_bloc.dart';
// import 'package:watsappchatscreen/bloc/chatbloc/chat_event.dart';
// import 'package:watsappchatscreen/bloc/chatbloc/chat_state.dart';
// import 'package:watsappchatscreen/bloc/imagepickerbloc/imagepicker_bloc.dart';
// import 'package:watsappchatscreen/bloc/imagepickerbloc/imagepicker_event.dart';
// import 'package:watsappchatscreen/bloc/imagepickerbloc/imagepicker_state.dart';

// // Import your BLoC components

// class ChatScreen extends StatelessWidget {
//   final String name;
//   final TextEditingController _messageController = TextEditingController();

//   ChatScreen({Key? key, required this.name}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF075E54),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Row(
//           children: [
//             const CircleAvatar(
//               backgroundColor: Color(0xFF128C7E),
//               radius: 20,
//             ),
//             const SizedBox(width: 10),
//             Text(
//               name,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//               icon: const Icon(
//                 Icons.videocam,
//                 color: Colors.white,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: const Icon(
//                 Icons.call,
//                 color: Colors.white,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: const Icon(
//                 Icons.more_vert,
//                 color: Colors.white,
//               ),
//               onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: context.read<ChatBloc>().messagesStream,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No messages yet.'));
//                 }

//                 final messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   padding: const EdgeInsets.all(16),
//                   itemBuilder: (context, index) {
//                     final messageData =
//                         messages[index].data() as Map<String, dynamic>;

//                     final messageText = messageData["message"] ?? "No message";
//                     final timestamp = messageData["timestamp"] as Timestamp?;
//                     final time = _formatTimestamp(timestamp);
//                     final isMe = messageData["isMe"] ?? false;

//                     return MessageBubble(
//                       message: messageText,
//                       time: time,
//                       isMe: isMe,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           BlocBuilder<ChatBloc, ChatState>(
//             builder: (context, state) {
//               if (state is ChatError) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Error: ${state.error}',
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 );
//               }

//               return BlocBuilder<ImagePickerBloc, ImagePickerState>(
//                 builder: (context, imageState) {
//                   return Column(
//                     children: [
//                       if (imageState is ImagePickedState)
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.file(
//                             File(imageState.imagePath),
//                             height: 200,
//                             width: 200,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.2),
//                               spreadRadius: 1,
//                               blurRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.emoji_emotions_outlined),
//                               onPressed: () {},
//                               color: Colors.grey,
//                             ),
//                             Expanded(
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 16),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(25),
//                                 ),
//                                 child: TextField(
//                                   controller: _messageController,
//                                   decoration: const InputDecoration(
//                                     hintText: 'Type a message',
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 context
//                                     .read<ImagePickerBloc>()
//                                     .add(PickImageEvent());
//                               },
//                               icon: const Icon(Icons.image),
//                               color: Colors.grey,
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.send),
//                               onPressed: () {
//                                 final messageText =
//                                     _messageController.text.trim();
//                                 if (messageText.isNotEmpty) {
//                                   context
//                                       .read<ChatBloc>()
//                                       .add(SendMessageEvent(messageText));
//                                   _messageController.clear();
//                                 }
//                               },
//                               color: Colors.grey,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   /// Helper function to format Firestore Timestamp into a readable time string
//   String _formatTimestamp(Timestamp? timestamp) {
//     if (timestamp == null) return 'Unknown time';
//     final dateTime = timestamp.toDate();
//     return DateFormat('hh:mm a').format(dateTime); // e.g., "02:30 PM"
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String message;
//   final String time;
//   final bool isMe;

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.time,
//     required this.isMe,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(
//           left: isMe ? 80 : 0,
//           right: isMe ? 0 : 80,
//           top: 4,
//           bottom: 4,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(message),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   time,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 if (isMe) ...[
//                   const SizedBox(width: 4),
//                   Icon(
//                     Icons.done_all,
//                     size: 16,
//                     color: Colors.blue[400],
//                   ),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watsappchatscreen/bloc/chatbloc/chat_bloc.dart';
import 'package:watsappchatscreen/bloc/chatbloc/chat_event.dart';
import 'package:watsappchatscreen/bloc/chatbloc/chat_state.dart';

class ChatScreen extends StatelessWidget {
  final String name;
  final TextEditingController _messageController = TextEditingController();

  ChatScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color(0xFF075E54),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: context.read<ChatBloc>().messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData =
                        messages[index].data() as Map<String, dynamic>;

                    final messageText = messageData["message"] ?? "No message";
                    final isImage = messageData["isImage"] ?? false;
                    final timestamp = messageData["timestamp"] as Timestamp?;
                    final time = _formatTimestamp(timestamp);
                    final isMe = messageData["isMe"] ?? false;

                    return MessageBubble(
                      message: messageText,
                      time: time,
                      isMe: isMe,
                      isImage: isImage,
                    );
                  },
                );
              },
            ),
          ),
          // Message Input Box
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.camera);

                        if (pickedFile != null) {
                          try {
                            // Define the Downloads directory path
                            final downloadsDir = Directory(
                                '/storage/emulated/0/Download/Images');

                            // Create the "Images" folder in Downloads if it doesn't exist
                            if (!downloadsDir.existsSync()) {
                              downloadsDir.createSync(recursive: true);
                            }

                            // Generate a unique file name
                            final fileName =
                                'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';

                            // Copy the image file to the Downloads/Images folder
                            final savedFile = await File(pickedFile.path)
                                .copy('${downloadsDir.path}/$fileName');

                            // Show a success message with the path
                            print("Saved image at ${savedFile.path}");

                            // Optionally send the image in the chat
                            context
                                .read<ChatBloc>()
                                .add(SendImageEvent(savedFile.path));
                          } catch (e) {
                            // Show an error message
                            print('Failed to save image: $e');
                          }
                        }
                      },
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final message = _messageController.text.trim();
                        if (message.isNotEmpty) {
                          context
                              .read<ChatBloc>()
                              .add(SendMessageEvent(message));
                          _messageController.clear();
                        }
                      },
                      color: const Color(0xFF128C7E),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown time';
    final dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final bool isImage;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.time,
    required this.isMe,
    required this.isImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isImage
                ? Image.file(
                    File(message),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                  ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
