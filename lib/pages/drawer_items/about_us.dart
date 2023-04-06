import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


//class AboutUs {
class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'About Us',
          style: GoogleFonts.kleeOne(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/peytamlogo.PNG',
                    height: 32,
                  ),
                  Text(
                    'DrukPeytam',
                    style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Text(
                'Druk Peytam was created by a group of final year IT students from College of Science and Technology. It is a product of our final year project.\n\nDruk Peytam app contains the intellectual sayings and proverbs that has been passed down from generations.\n\nThe main aim is to promote and preserve this cultural aspect of our country, Bhutan.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.kleeOne(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              ListTile(
                title: Text(
                  'Developers:',
                  style: GoogleFonts.kleeOne(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Tashi Wangchuk',
                  style: GoogleFonts.kleeOne(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                onTap: () {
                  // Logout functionality
                },
                trailing: const Icon(
                  Icons.mail_rounded,
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text(
                  'Tashi Pelden',
                  style: GoogleFonts.kleeOne(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                onTap: () {
                  // Logout functionality
                },
                trailing: const Icon(
                  Icons.mail_rounded,
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text(
                  'Namgay Wangchuk',
                  style: GoogleFonts.kleeOne(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                onTap: () {
                  // Logout functionality
                },
                trailing: const Icon(
                  Icons.mail_rounded,
                  color: Colors.blue,
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  'Project Guide:',
                  style: GoogleFonts.kleeOne(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Kezang Dema',
                  style: GoogleFonts.kleeOne(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                onTap: () {
                  // Logout functionality
                },
                trailing: const Icon(
                  Icons.mail_rounded,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
