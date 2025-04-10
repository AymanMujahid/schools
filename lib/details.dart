import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:schools/config/routing.dart';
import 'package:schools/shared_components/colors.dart';
import 'package:sweet_snackbar/sweet_snackbar.dart';
import 'package:sweet_snackbar/top_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comments.dart';

class SchoolDetails extends StatefulWidget {
  const SchoolDetails(
      {Key? key, this.data, required this.id, required this.count, this.tag})
      : super(key: key);
  final data;
  final String id;
  final tag;
  final int count;

  @override
  _SchoolDetailsState createState() => _SchoolDetailsState();
}

class _SchoolDetailsState extends State<SchoolDetails> {
  double rate = 0;
  double selectedRate = 0;
  double initialRate = 0;

  @override
  void initState() {
    rate = double.parse(widget.data['rate'].toString());
    getRate();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Hero(
              tag: widget.tag.toString(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(widget.data['image']),
                  fit: BoxFit.cover,
                )),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 10, 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.height,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 32,
                                  color: Colors_().primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 12,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Text(
                    widget.data['name'],
                    style: TextStyle(
                        color: Colors_().primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Schyler'),
                  )),
            ],
          ),
          const Divider(),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Text(
                widget.data['description'],
              )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              thickness: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'School details: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          IconlyBold.info_circle,
                          color: Colors_().primary,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.data['category'] + " School",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors_().primary),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors_().primary,
                          size: 22,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.data['location'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors_().primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder(
                      future: getRate(),
                      builder: (con, text) {
                        return InkWell(
                          onTap: () {
                            if (FirebaseAuth.instance.currentUser != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      actions: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Cancel'),
                                            )),
                                        InkWell(
                                            onTap: () {
                                              int count = widget.count;
                                              count++;

                                              double newRate =
                                                  (rate + selectedRate) / count;
                                              setState(() {});

                                              FirebaseDatabase.instance
                                                  .ref('Schools')
                                                  .child(widget.id)
                                                  .child('count')
                                                  .set(count);
                                              FirebaseDatabase.instance
                                                  .ref('Schools')
                                                  .child(widget.id)
                                                  .child('rate')
                                                  .set(newRate);
                                              Navigator.pop(context);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Rate'),
                                            )),
                                      ],
                                      title: const Text('Rate school'),
                                      content: RatingBar(
                                        initialRating: selectedRate,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ratingWidget: RatingWidget(
                                          full: const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          half: const Icon(
                                            Icons.star_half,
                                            color: Colors.amber,
                                          ),
                                          empty: Icon(
                                            Icons.star,
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            selectedRate = rating;
                                          });
                                        },
                                      ));
                                },
                              );
                            } else {
                              showTopSnackBar(
                                  context,
                                  const CustomSnackBar.info(
                                      message: 'Please login to give a rate'));
                            }
                          },
                          child: RatingBarIndicator(
                            rating: initialRate,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 24.0,
                            direction: Axis.horizontal,
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 6,
                  ),
                  InkWell(
                    onTap: () {
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.of(context)
                            .push(Routing().createRoute(CommentsPage(
                          id: widget.id,
                          name: widget.data['name'],
                        )));
                      } else {
                        showTopSnackBar(
                            context,
                            const CustomSnackBar.info(
                                message: 'Please login to view comments'));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors_().primary,
                          borderRadius: BorderRadius.circular(12)),
                      height: 40,
                      width: 100,
                      child: const Center(
                        child: Text(
                          'Comments',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Schyler'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  'Social: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  const Text('Phone:  '),
                  InkWell(
                    onTap: () {
                      launch("tel://${widget.data['phone']}");
                    },
                    child: Text(
                      " ${widget.data['phone'].toString().replaceAll(':', '')}",
                      style: TextStyle(color: Colors_().primary),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  launch(widget.data['facebook'].toString()).then((value) {
                    showTopSnackBar(context,
                        const CustomSnackBar.info(message: "Opening facebook"));
                  }).onError((error, stackTrace) {
                    print(error);
                    showTopSnackBar(
                        context,
                        const CustomSnackBar.error(
                            message: "Couldn't open link!"));
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors_().primary,
                      borderRadius: BorderRadius.circular(12)),
                  height: 40,
                  width: 120,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Facebook',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Schyler'),
                        ),
                        Icon(
                          Icons.facebook,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox()
            ],
          )
        ]),
      )),
    );
  }

  Future<double> getRate() async {
    FirebaseDatabase.instance
        .ref('Schools')
        .child(widget.id.toString())
        .child('rate')
        .get()
        .then((value) {
      setState(() {
        rate = double.parse(value.value.toString());
        initialRate = double.parse(value.value.toString());
      });
    });
    return initialRate;
  }
}
