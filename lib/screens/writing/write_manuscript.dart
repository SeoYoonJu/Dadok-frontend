// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class WriteManuscriptPage extends StatefulWidget {
//   const WriteManuscriptPage({Key? key}) : super(key: key);
//
//
//   @override
//   _WriteManuscriptPageState createState() => _WriteManuscriptPageState();
// }
//
// class _WriteManuscriptPageState extends State<WriteManuscriptPage> {
//   // Profile Data
//   String content = '';
//   String author = '';
//   bool isLoading = true;
//
//   // Fetch Profile Data from API using token
//   Future<void> _getScriptData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('authToken'); // Retrieve saved token
//
//     if (token == null) {
//       // If there's no token, display a message or handle it
//       print('No token found, please log in');
//       return;
//     }
//
//     final response = await http.get(
//       Uri.parse('http://localhost:8080/manuscript'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//
//     if (response.statusCode == 200) {
//       final responseBody = utf8.decode(response.bodyBytes);
//       final data = json.decode(responseBody);
//       if (data['isSuccess'] == true) {
//         setState(() {
//           content = data['data']['content'];
//           author = data['data']['author'];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getScriptData(); // Fetch profile data when the page loads
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const double topSectionHeight = 620;
//
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: [
//               SizedBox(
//                 height: topSectionHeight,
//                 child: Stack(
//                     children: [
//                       Container(
//                         height: topSectionHeight * 0.9,
//                         width: double.infinity,
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Color(0xFF44B1F0),
//                               Color(0xFF874FFF),
//                             ],
//                           ),
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(20),
//                             bottomRight: Radius.circular(20),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 30,
//                         left: 0,
//                         right: 0,
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Image.asset(
//                             'assets/images/main.png', // Adjust path accordingly
//                             width: 150,
//                           ),
//                         ),
//                       ),
//                     ]
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//
// class WriteManuscriptPage extends StatefulWidget {
//   const WriteManuscriptPage({Key? key}) : super(key: key);
//
//   @override
//   _WriteManuscriptPageState createState() => _WriteManuscriptPageState();
// }
//
// class _WriteManuscriptPageState extends State<WriteManuscriptPage> {
//   // Profile Data
//   String content = '';
//   String author = '';
//   bool isLoading = true;
//
//   // Fetch Profile Data from API using token
//   Future<void> _getScriptData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('authToken'); // Retrieve saved token
//
//     if (token == null) {
//       // If there's no token, display a message or handle it
//       print('No token found, please log in');
//       return;
//     }
//
//     final response = await http.get(
//       Uri.parse('http://localhost:8080/scripts/today'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//
//     if (response.statusCode == 200) {
//       final responseBody = utf8.decode(response.bodyBytes);
//       final data = json.decode(responseBody);
//       if (data['isSuccess'] == true) {
//         setState(() {
//           content = data['data']['content'];
//           author = data['data']['author'];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getScriptData(); // Fetch profile data when the page loads
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const double topSectionHeight = 620;
//
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: [
//               SizedBox(
//                 height: topSectionHeight,
//                 child: Stack(
//                   children: [
//                     Container(
//                       height: topSectionHeight * 0.9,
//                       width: double.infinity,
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Color(0xFF44B1F0),
//                             Color(0xFF874FFF),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(20),
//                           bottomRight: Radius.circular(20),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 30,
//                       left: 0,
//                       right: 0,
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Image.asset(
//                           'assets/images/main.png', // Adjust path accordingly
//                           width: 150,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: topSectionHeight * 0.15,
//                       left: 20,
//                       right: 20,
//                       child: Container(
//                         padding: const EdgeInsets.all(16.0),
//                         child: isLoading
//                             ? const Center(child: CircularProgressIndicator())
//                             : Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '$author',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),textAlign: TextAlign.center,
//                             ),
//                             Text(
//                               content.isNotEmpty ? $content : 'No content available.',
//                               style: const TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
class WriteManuscriptPage extends StatefulWidget {
  const WriteManuscriptPage({Key? key}) : super(key: key);

  @override
  _WriteManuscriptPageState createState() => _WriteManuscriptPageState();
}

class _WriteManuscriptPageState extends State<WriteManuscriptPage> {
  String content = '';
  String author = '';
  bool isLoading = true;

  Future<void> _getScriptData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authToken');

    if (token == null) {
      print('No token found, please log in');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/scripts/today'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);

        setState(() {
          content = data['content'] ?? '';
          author = data['author'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getScriptData();
  }

  @override
  Widget build(BuildContext context) {
    const double topSectionHeight = 620;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(
                height: topSectionHeight,
                child: Stack(
                  children: [
                    Container(
                      height: topSectionHeight * 0.9,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF44B1F0),
                            Color(0xFF874FFF),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/main.png',
                          width: 150,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            "오늘의 필사",
                            style: const TextStyle(
                              fontFamily: 'Gowun-regular',
                              color: Colors.white,
                              fontSize: 28,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "___________________________",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: topSectionHeight * 0.3,
                      left: 30,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              content,
                              style: const TextStyle(
                                fontFamily: 'Gowun-regular',
                                color: Colors.white,
                                fontSize: 32,
                                height: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              author,
                              style: const TextStyle(
                                fontFamily: 'Gowun-regular',
                                color: Colors.white,
                                fontSize: 24,
                                height: 3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}