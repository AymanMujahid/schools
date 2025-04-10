import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:schools/shared_components/colors.dart';
import 'package:schools/shared_components/style.dart';
import 'package:sweet_snackbar/sweet_snackbar.dart';
import 'package:sweet_snackbar/top_snackbar.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({Key? key, this.id, this.name}) : super(key: key);
  final id;
  final name;

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController comment = TextEditingController();
  int textLength = 0;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  void dispose() {
    comment.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors_().primary,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 12,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Text(
                    'Comments',
                    style: TextStyle(
                        color: Colors_().primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: 'Schyler'),
                  )),
            ],
          ),
          const Divider(),
          Expanded(
            child: FirebaseAnimatedList(
              query: FirebaseDatabase.instance
                  .ref('Schools')
                  .child(widget.id.toString())
                  .child('comments'),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                print(snapshot.ref.root.key);
                Map<String, dynamic> data =
                    jsonDecode(jsonEncode(snapshot.value));
                return Padding(
                    padding: const EdgeInsets.only(right: 30, top: 12),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors_().primary.withOpacity(.7),
                          borderRadius: BorderRadiusDirectional.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey[100]!,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20))),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                ),
                                const Text('By: '),
                                Expanded(
                                  child: Text(
                                    ' ' + data['by'],
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Builder(builder: (context) {
                                  if (data['by'].toString() ==
                                      FirebaseAuth.instance.currentUser!.email
                                          .toString()) {
                                    return InkWell(
                                        onTap: () {
                                          FirebaseDatabase.instance
                                              .ref(snapshot.ref.path)
                                              .child(snapshot.key.toString())
                                              .remove()
                                              .then((value) {
                                            showTopSnackBar(
                                                context,
                                                const CustomSnackBar.info(
                                                    message:
                                                        'Comment deleted!'));
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors_().primary,
                                          ),
                                        ));
                                  } else {
                                    return Container();
                                  }
                                }),
                                const SizedBox(
                                  width: 12,
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    data['text'].toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Schyler',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Builder(builder: (context) {
                                    DateTime dateTime =
                                        DateTime.parse(data['date'].toString());

                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd – hh:mm')
                                            .format(dateTime);

                                    return Text(
                                      formattedDate.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Schyler'),
                                    );
                                  }),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ));
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _key,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: comment,
                    onChanged: (value) {
                      setState(() {
                        textLength = value.length;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Username';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                      suffixIcon: textLength > 0
                          ? InkWell(
                              onTap: () {
                                FirebaseDatabase.instance
                                    .ref('Schools')
                                    .child(widget.id.toString())
                                    .child('comments')
                                    .push()
                                    .set({
                                  "text": comment.text,
                                  "date": DateTime.now().toString(),
                                  "by": FirebaseAuth.instance.currentUser!.email
                                      .toString(),
                                });
                                FocusManager.instance.primaryFocus?.unfocus();
                                comment.clear();
                                setState(() {
                                  textLength = 0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors_().primary),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    IconlyBold.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.transparent),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                      hintText: 'Enter Comment',
                      hintStyle: MyStyles().hintText,
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    onSaved: (String? value) {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
