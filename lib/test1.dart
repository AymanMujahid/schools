import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Test1 extends StatefulWidget {
  const Test1({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            FirebaseDatabase.instance.ref('Schools').push().set({
              "category": "International",
              'comments':{},
              "count": 0,
              "description":'مدرسة قدموس الدولية - Cadmus International School العاصمة الجديدة - القاهرة يعتمد منهج مدرسة قدموس الدولية - Cadmus International School على الأسس التي تضعها منظمة سايبس العالمية(SABIS) ادارة المدرسة تابعة لادارة مدرسة الشويفات ولكن الاختلاف ان مدرسة قدموس هي مدرسة دولية معتمدة وهيئة التدريس مصرية العام الدراسي الاول لـمدرسة قدموس الدولية - Cadmus International School هو 2022/2023 و تستقبل حتي الصف السادس (Grade 6) و باقي الصفوف علي قائمة الانتظار.',
              "facebook": 'https://www.facebook.com/CISBaghdad/',
              "image": "https://scontent.fbey15-1.fna.fbcdn.net/v/t1.6435-9/161087267_825858221474942_2579011898781011678_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=F7O6-eVAljwAX_mQaqc&_nc_ht=scontent.fbey15-1.fna&oh=00_AT9Gke0r8iPYIRL3_zeDKAMWuKK1khhZfF2-3l9PyMvYkA&oe=62B16125",
              "location": 'Cairo',
              "name": 'Cadmus International School',
              "phone": '011 0225 4000',
              "price": "62000 LE - 89000 LE",
              "rate": 0.0,
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Text('send'),
          ),
        ),
      ),
    );
  }
}
