import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../data/models/message_model.dart';
import '../components/chat_component_from_friend.dart';
import '../components/chat_component_from_you.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> messagesList = [];

  TextEditingController controller = TextEditingController();

  final ScrollController scrollController = ScrollController();

  void scrollDown() {
    scrollController.animateTo(
      0,
      duration: const Duration(seconds: 2),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app Bar
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Chat'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                // reverse: true,
                controller: scrollController,
                itemCount: messagesList.length,
                itemBuilder: (ctx, index) {
                  return messagesList[index].name == 'Ammar'
                      ? ChatComponentFromYou(
                          message: messagesList[index].message,
                          time: messagesList[index].time,
                        )
                      : ChatComponentFromFriend(
                          message: messagesList[index].message,
                          time: messagesList[index].time,
                          name: messagesList[index].name,
                        );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: IconButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      messagesList.add(MessageModel.fromJson({
                        'message': controller.text,
                        'time': Timestamp.now(),
                        'name': 'Ammar',
                      }));

                      controller.clear();
                     setState(() {
                        messagesList.sort((a,b)=> a.time.compareTo(b.time));
                      }); scrollDown();
                      
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
