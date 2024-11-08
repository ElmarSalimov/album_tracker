
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify_app/data/models/playlist.dart';
import 'package:spotify_app/data/services/api.dart';
import 'package:spotify_app/data/services/auth.dart';
import 'package:spotify_app/screens/home_screen.dart';
import 'package:spotify_app/util/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String lastOpenedUrl = '';
  var playlistData;

  late AppLinks appLinks;
  final ApiService apiService = ApiService();
  final AuthService authService = AuthService();
  List<Playlist> playlists = [];

  @override
  void initState() {
    appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) async {
      lastOpenedUrl = uri.toString();

      setState(() {
        final accessTokenRegExp = RegExp(r'access_token=([^&]+)');
        final match = accessTokenRegExp.firstMatch(lastOpenedUrl);

        if (match != null) {
          setState(() {
            accessToken = match.group(1)!;
            Clipboard.setData(ClipboardData(text: accessToken));
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
        }
      });
    }, onError: (e) => print(e.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("Song Guesser App", style: GoogleFonts.montserrat(
      //     textStyle: const TextStyle(
      //       fontSize: 20,
      //       color: Colors.white
      //     )
      //   ) ,),
      //   backgroundColor: Colors.grey.shade700,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome To Song Guesser",
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              )),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                authService.logIn();
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(28, 186, 83, 30),
                    borderRadius: BorderRadius.circular(24)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const FaIcon(
                    FontAwesomeIcons.spotify,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Sign in with spotify",
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    )),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: authService.logIn,
            child: const Icon(Icons.login),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
