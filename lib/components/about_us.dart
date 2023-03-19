import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//class AboutUs {
class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 255, 152, 18)));
    return Scaffold(
        appBar: AppBar(
          title: const Text('About Us'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 152, 18),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: const Text(
                          'Druk Paytam was created by a group of final year students from College of Science and Technology. It is a product of the final year project. ')),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: const Text(
                          'Druk Paytam app contains the intellectual sayings and proverbs that has been passed down from generations.')),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: const Text(
                          'The main aim is to promote and preserve the cultural aspect of our country, Bhutan'))
                ])),
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: const Text(
                          'Developers',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(child: Text('Tashi Wangchuk')),
                    const SizedBox(child: Text('Tashi Pelden')),
                    const SizedBox(child: Text('Namagay Wangchuk'))
                  ],
                )),
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: const Text('Project Guide',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    const SizedBox(child: Text('Mrs.Kezang Dema')),
                  ],
                )),
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: const Text('Special Thanks to:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    const SizedBox(child: Text('Dr.Dorji Thinley')),
                  ],
                ))
          ]),
        ));
  }
}
//}