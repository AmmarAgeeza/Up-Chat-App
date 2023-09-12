import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_chat_app/feature/auth/presentation/cubit/auth_cubit.dart';

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
  // List<MessageModel> messagesList = [];

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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              List<MessageModel> messagesList = [];
              for (var i in snapshot.data!.docs) {
                messagesList.add(MessageModel.fromJson(i));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        controller: scrollController,
                        itemCount: messagesList.length,
                        itemBuilder: (ctx, index) {
                          return messagesList[index].name ==
                                  BlocProvider.of<AuthCubit>(context)
                                      .userModel!
                                      .name
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
                              // messagesList.add(MessageModel.fromJson({
                              //   'message': controller.text,
                              //   'time': Timestamp.now(),
                              //   'name': 'Anas',
                              // }));
                              FirebaseFirestore.instance
                                  .collection('messages')
                                  .add({
                                'message': controller.text,
                                'time': Timestamp.now(),
                                'name': BlocProvider.of<AuthCubit>(context)
                                    .userModel!
                                    .name
                              });
                              controller.clear();
                              // setState(() {});
                              scrollDown();
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            
          }),
    );
  }
}
