import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:schools/config/routing.dart';
import 'package:schools/details.dart';
import 'package:schools/shared_components/colors.dart';
import 'package:schools/shared_components/style.dart';
import 'package:schools/welcome.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  int textLength = 0;

  @override
  void dispose() {
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  String name = '';

  final GlobalKey<FormState> _key = GlobalKey();
  bool searchPressed = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .push(Routing().createRoute(WelcomePage()));
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors_().primary,
                  ));
            })
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors_().primary,
          automaticallyImplyLeading: false,
          title: Builder(builder: (context) {
            if (FirebaseAuth.instance.currentUser == null) {
              return const Text('Explore Schools');
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Form(
                      key: _key,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            name = searchController.text.toString();
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
                                    setState(() {
                                      name = searchController.text.toString();
                                      searchPressed = true;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors_().primary),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.search,
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                          hintText: 'Search schools',
                          hintStyle: MyStyles().hintText,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                        ),
                        onSaved: (String? value) {},
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: searchPressed
                        ? FirebaseAnimatedList(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            query: FirebaseDatabase.instance.ref('Schools'),
                            itemBuilder: (BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index) {
                              Map<String, dynamic> data =
                                  jsonDecode(jsonEncode(snapshot.value));

                              if (data['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name)||data['price']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name)||data['rate']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name)||data['location']
                                  .toString()
                                  .toLowerCase()
                                  .contains(name)) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        Routing().createRoute(SchoolDetails(
                                      tag: index.toString(),
                                      count: data['count'],
                                      id: snapshot.key.toString(),
                                      data: data,
                                    )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey[200]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: Colors.grey[200]),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.0),
                                                    child: Image.network(
                                                      data['image'],
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                        const SizedBox(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['name'].toString().length >
                                                      20
                                                  ? '${data['name'].toString().substring(0, 17)}...'
                                                  : data['name'].toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Schyler'),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              data['price'].toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Schyler',
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              IconlyBold.star,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                                data['rate'].toString().length >
                                                        3
                                                    ? data['rate']
                                                        .toString()
                                                        .substring(0, 3)
                                                    : data['rate'].toString())
                                          ],
                                        ),
                                        const SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : FirebaseAnimatedList(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            query: FirebaseDatabase.instance.ref('Schools'),
                            itemBuilder: (BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index) {
                              Map<String, dynamic> data =
                                  jsonDecode(jsonEncode(snapshot.value));
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(Routing().createRoute(SchoolDetails(
                                    tag: index.toString(),
                                    count: data['count'],
                                    id: snapshot.key.toString(),
                                    data: data,
                                  )));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.grey[200]),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22.0),
                                                  child: Hero(
                                                    tag: index.toString(),
                                                    child: Image.network(
                                                      data['image'],
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                      const SizedBox(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['name'].toString().length > 20
                                                ? '${data['name'].toString().substring(0, 17)}...'
                                                : data['name'].toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Schyler'),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            data['price'].toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Schyler',
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            IconlyBold.star,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                              data['rate'].toString().length > 3
                                                  ? data['rate']
                                                      .toString()
                                                      .substring(0, 3)
                                                  : data['rate'].toString())
                                        ],
                                      ),
                                      const SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
