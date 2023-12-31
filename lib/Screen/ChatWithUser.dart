import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:eshopmultivendor/Helper/Color.dart' as theme;
import 'dart:convert' as convert;
import '../Helper/String.dart';



class ChatWithUser extends StatefulWidget {
  String id, fuid, name, mobile;
  final types.Room room;
  final fcm;

  ChatWithUser(
      {required this.id,required this.fuid, required this.name,required this.mobile, required this.room, this.fcm});

  @override
  _ChatWithUserState createState() => _ChatWithUserState();
}

class _ChatWithUserState extends State<ChatWithUser> {

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.name}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      //await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
    //  addMessage(message.text.toString());
    addNote(widget.fcm, widget.room.users[1].firstName.toString(), message.text.toString());


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  getDetails() {
    for (int i = 0; i < widget.room.users.length; i++) {
      print(widget.room.users[i].firstName);
    }
  }
  BoxDecoration boxDecoration(
      {double radius = 10.0,
        Color color = Colors.transparent,
        Color bgColor = Colors.white,
        var showShadow = false}) {
    return BoxDecoration(
      color: bgColor,
      boxShadow: showShadow
          ? [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1)
      ]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.white,
          leading: Container(
            margin: EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: theme.primary,
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                    color: theme.primary, fontWeight: FontWeight.normal),
              ),
              Text(
                widget.mobile,
                style: TextStyle(
                    color: theme.primary, fontWeight: FontWeight.normal),
              ),
            ],
          ),

        ),
        body: StreamBuilder<types.Room>(
          initialData: widget.room,
          stream: FirebaseChatCore.instance.room(widget.room.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<List<types.Message>>(
                initialData: const [],
                stream: FirebaseChatCore.instance.messages(snapshot.data!),
                builder: (context, snapshot) {
                  print('snapshot.data... ${snapshot.data}');
                  return Chat(
                    messages: snapshot.data ?? [],
                    onMessageTap: _handleMessageTap,
                    onPreviewDataFetched: _handlePreviewDataFetched,
                    onSendPressed: _handleSendPressed,
                    showUserAvatars: true,
                    showUserNames: true,
                    isAttachmentUploading: true,

                    theme: DefaultChatTheme(
                      primaryColor: theme.primary,
                      seenIcon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      inputContainerDecoration: boxDecoration(
                        radius: 10,
                        bgColor: Color(0xffF3F3F5),
                        color: Colors.grey.shade300,
                        showShadow: true,
                      ),
                      deliveredIcon: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      inputMargin: EdgeInsets.all(10),
                      inputTextColor: Colors.grey,
                      inputBackgroundColor: Colors.white,
                      backgroundColor: Color(0xffF2F4F8),
                    ),
                    user: types.User(
                      id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                      imageUrl:  FirebaseChatCore.instance.firebaseUser?.photoURL ?? '',
                      firstName:  FirebaseChatCore.instance.firebaseUser?.displayName ?? '',
                    ),
                  );
                },
              );
            } else {
              return Chat(
                messages: [],
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                theme: DefaultChatTheme(
                  primaryColor: theme.primary,
                  seenIcon: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  inputContainerDecoration: boxDecoration(
                    radius: 10,
                    bgColor: Color(0xffF3F3F5),
                    color: Colors.grey.shade300,
                    showShadow: true,
                  ),
                  deliveredIcon: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  inputMargin: EdgeInsets.all(10),
                  inputTextColor: Colors.grey,
                  inputBackgroundColor: Colors.white,
                  backgroundColor: Color(0xffF2F4F8),
                ),
                user: types.User(
                  id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                  imageUrl:  FirebaseChatCore.instance.firebaseUser?.photoURL ?? '',
                  firstName:  FirebaseChatCore.instance.firebaseUser?.displayName ?? '',

                ),
              );
            }
          },
        ),
      ),
    );
  }

  bool _isNetworkAvail = true;


  Future<Null> addMessage(body) async {
    try {
      var parameter = {
        // "from_user_id": CUR_USERID,
        "to_user_id": widget.id,
        "message": body,
        "type": "1"
      };
      print(parameter);
      // Response response = await post(Uri.parse(baseUrl + "setMessage"),
      //     body: parameter, headers: {}).timeout(Duration(seconds: timeOut));

      // var getdata = json.decode(response.body);
      // print(getdata);
    } on TimeoutException catch (_) {

    }
    return null;
  }

  Future<Null> addNote(fcm, title, body) async {
    try {
      var parameter = {
        "title": title,
        "receiver_id": widget.id,
        "type": "chat",
        "fuid": widget.fcm,
        "body": body,
      };
      print(parameter);
      var params = {
        'user_id' : widget.id
      };

      print("url is $noti_chat");
      print("params is $params");

      var response = await http.post(noti_chat, body: params);
      var jsonResponse = convert.jsonDecode(response.body);
      print("chat noti message = ${jsonResponse['message']}");
    } on TimeoutException catch (_) {

    }
    return null;
  }


//   Future <void> sendNotification(
//       {String? receiverId, String? body, String? fuid, String? title})async{
//
//
//
//
//     var parameter = {ReceiverId:receiverId,Type: 'chat', Body: body, FuId: fuid, MessageTitle: title };
//     apiBaseHelper.doctorPostAPICall(sendNotificationRequest, parameter).then(
//             (getData) {
//
//           bool error = getData["error"];
//           String? msg = getData["message"];
//
//           if (!error) {
//
//
//           }
//
//         });
//
//   }
}