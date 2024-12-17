import 'package:flutter/material.dart';
import 'package:watsappchatscreen/view/chatscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text(
          'WhatsApp',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body: ListView(
        children: const [
          ChatListTile(
            name: 'Sarath',
            message: 'Hey, how are you?',
            time: '10:30 AM',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat),
        onPressed: () {},
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  // final int unreadCount;

  const ChatListTile({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    // required this.unreadCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF128C7E),
        radius: 25,
        child: Text(
          name[0],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF25D366),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            child: const Text(
              "2",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              name: name,
            ),
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:watsappchatscreen/bloc/chatbloc/chat_bloc.dart';
// import 'package:watsappchatscreen/bloc/chatbloc/chat_event.dart';
// import 'package:watsappchatscreen/bloc/chatbloc/chat_state.dart';

// class ChatScmreen extends StatelessWidget {
//   final TextEditingController messageController = TextEditingController();

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ChatBloc()..add(LoadMessagesEvent()),
//       child: Scaffold(
//         appBar: AppBar(title: Text('Chat')),
//         body: Column(
//           children: [
//             Expanded(
//               child: BlocBuilder<ChatBloc, ChatState>(
//                 builder: (context, state) {
//                   if (state is ChatLoadingState) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (state is ChatLoadedState) {
//                     return ListView.builder(
//                       itemCount: state.messages.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(title: Text(state.messages[index]));
//                       },
//                     );
//                   } else if (state is ChatErrorState) {
//                     return Center(child: Text('Error: ${state.error}'));
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: messageController,
//                       decoration: InputDecoration(
//                         labelText: 'Enter message',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: () {
//                       if (messageController.text.isNotEmpty) {
//                         context
//                             .read<ChatBloc>()
//                             .add(SendMessageEvent(messageController.text));
//                         messageController.clear();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
