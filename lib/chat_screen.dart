import 'package:chat_bot/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chat_repository.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final _scrollController = ScrollController();
  late bool isLoading;

  get kTranslateModelV3 => null;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/bot.png",
              height: 45,width: 45,),
              SizedBox(width: 5,),
              Text('ChatBot App', style: TextStyle(fontSize: 25),),
            ],
          ),
        ),
        ),
      body: Column(children: [
        Flexible(
          child: ListView.builder(
            reverse: false,
            padding: Vx.m8,
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (BuildContext context, int index) {
              return _messages[index];
            },
          ),
        ),
        Visibility(
            visible: isLoading,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )),
        Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            border: Border.all(width: 0.1),
          ),
          child: _buildtextcomposer(),
        )
      ]),
    );
  }

  Widget _buildtextcomposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) => _sendMessage(),
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: "Send a Message"),
          ),
        ),
        IconButton(onPressed: () => _sendMessage(), icon: Icon(Icons.send)),
      ],
    ).p8();
  }

  void _sendMessage() async {
    setState(
      () {
        _messages.add(
          ChatMessage(
            text: _controller.text,
            sender: "User",
          ),
        );
        isLoading = true;
      },
    );
    var input = _controller.text;
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 50)).then((_) => _scrollDown());
    generateResponse(input).then((value) {
      setState(() {
        isLoading = false;
        _messages.add(
          ChatMessage(
            text: value,
            sender: "Bot",
          ),
        );
      });
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 50)).then((_) => _scrollDown());
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

   // if (_controller.text.isEmpty) return;
    // ChatMessage message = ChatMessage(
    //   text: _controller.text,
    //   sender: "user",
    // );
    // // ChatMessage message = ChatMessage(text: _controller.text, sender: "user");
    // setState(() {
    //   _messages.insert(0, message);
    // });

    // _controller.clear();
    // final request =
    //     CompleteText(prompt: message.text, model: kTranslateModelV3);
    // _subscription = chatGPT!
    //     .build(token: "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")
    //     .onCompletionStream(request: request)
    //     .listen((response) {
    //   Vx.log(response!.choices[0].text);
    //   ChatMessage botMessage =
    //       ChatMessage(text: response.choices[0].text, sender: "bot");

    //   setState(() {
    //     _messages.insert(0, botMessage);
    //   });
    // });