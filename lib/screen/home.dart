import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_animated/screen/login.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  Stream<QuerySnapshot> postsStream = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 3.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 28.0,
                            backgroundImage: NetworkImage(userData['profile']),
                            backgroundColor: Colors.deepPurple,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const LoginPage(),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              },
                              color: Colors.deepPurple[400],
                              icon: const Icon(
                                Icons.login,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "My Notes",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // notes
                // Expanded(
                //   child: StreamBuilder<QuerySnapshot>(
                //     stream: FirebaseFirestore.instance
                //         .collection('notes')
                //         .snapshots(),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) {
                //         return const Center(child: CircularProgressIndicator());
                //       }
                //       List<DocumentSnapshot> docs = snapshot.data!.docs;
                //       return GridView.builder(
                //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //         primary: true,
                //         gridDelegate:
                //             const SliverGridDelegateWithMaxCrossAxisExtent(
                //           maxCrossAxisExtent:
                //               200.0, // maximum width for each item
                //           crossAxisSpacing: 25.0,
                //           mainAxisSpacing: 25.0,
                //         ),
                //         itemCount: docs.length,
                //         itemBuilder: (context, index) {
                //           final title = docs[index]['title'];
                //           final color = index % 2 == 0
                //               ? Colors.deepPurple
                //               : Colors
                //                   .deepOrange; // alternate colors for each item
                //           return Container(
                //             height: 150.0 +
                //                 index * 10.0, // increase height for each item
                //             decoration: BoxDecoration(
                //               color: color,
                //               borderRadius: BorderRadius.circular(12),
                //             ),
                //             child: Center(
                //               child: Text(
                //                 title,
                //                 style: TextStyle(
                //                   fontSize: 16.0 + index * 2.0,
                //                 ), // increase font size for each item
                //               ),
                //             ),
                //           );
                //         },
                //       );
                //     },
                //   ),
                // ),

                // notes
                // Expanded(
                //   child: StreamBuilder<QuerySnapshot>(
                //     stream: FirebaseFirestore.instance
                //         .collection('notes')
                //         .snapshots(),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasError) {
                //         return Text('Error: ${snapshot.error}');
                //       }
                //       if (!snapshot.hasData) {
                //         return const Center(child: CircularProgressIndicator());
                //       }
                //       final notes = snapshot.data!.docs;
                //       return MasonryGridView.builder(
                //         mainAxisSpacing: 25.0,
                //         crossAxisSpacing: 0.0,
                //         gridDelegate:
                //             const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 2,
                //         ),
                //         itemBuilder: (context, index) {
                //           final note = notes[index];
                //           return Padding(
                //             padding:
                //                 const EdgeInsets.symmetric(horizontal: 15.0),
                //             child: Container(
                //               height: 220,
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(12),
                //                 color: Colors.deepPurple,
                //               ),
                //               child: Text(note['title']),
                //             ),
                //           );
                //         },
                //         itemCount: notes.length,
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('An error occurred while loading user data.'),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
