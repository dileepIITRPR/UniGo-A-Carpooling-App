import 'package:carpool/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  Future _makeEmail(String email) async {
    var url = Uri.parse("mailto:$email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 28,
            ),
            Ink.image(
              image: Image.asset("assets/images/iitrpr.jpg").image,
              fit: BoxFit.fill,
              width: 170,
              height: 180,
            ),
            const SizedBox(
              height: 28,
            ),
            const Text(
              'About Us',
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // const Text(
            //   'Department of CSE IITRPR',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 24,
            //   ),
            // ),
            // const SizedBox(
            //   height: 18,
            // ),
            // const Text(
            //   'Mentor',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 22,
            //   ),
            // ),
            // const Text(
            //   'Dr. Puneet Goyal',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 20,
            //   ),
            // ),
            // const SizedBox(
            //   height: 16,
            // ),
            // const Text(
            //   'Team T11 - Members',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 22,
            //   ),
            // ),
            // const SizedBox(
            //   height: 3,
            // ),
            // const Text(
            //   'Aman Pankaj Adatia - 2020CSB1154',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 18,
            //   ),
            // ),
            // const Text(
            //   'Anubhav Kataria - 2020CSB1073',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 18,
            //   ),
            // ),
            // const Text(
            //   'Sanyam Walia - 2020CSB1122',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 18,
            //   ),
            // ),
            // const Text(
            //   'Dileep Kumar Kanwat - 2020CSB1085',
            //   style: TextStyle(
            //     // fontWeight: FontWeight.bold,
            //     fontWeight: FontWeight.w500,
            //     fontSize: 18,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: const Text(
                  'We are a team of CSE students and faculty. This app is developed as a part of Development Engineering Project (DEP) course at IIT Ropar. This app can be currently used only by members of IIT Ropar. ',
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            // CustomButton(
            //     buttonText: 'Contact Us',
            //     buttonClicked: () {
            //       _makeEmail('2020csb1154@iitrpr.ac.in');
            //     })
          ],
        ),
      ),
    );
  }
}
