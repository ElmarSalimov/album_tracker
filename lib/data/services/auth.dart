import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  
  // Log in function
  void logIn() {
    const String clientId =
        '2888fc59c0e14a15b227bdf4f0b129b6'; // Replace with your actual client ID
    const String redirectUri = 'elmarskoy://elmarinko.dev';
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    final String state =
        List.generate(16, (index) => chars[random.nextInt(chars.length)])
            .join();
    const String scope =
        'user-read-private user-read-email playlist-read-private';

    String url = 'https://accounts.spotify.com/authorize'
        '?response_type=token'
        '&client_id=${Uri.encodeComponent(clientId)}'
        '&scope=${Uri.encodeComponent(scope)}'
        '&redirect_uri=${Uri.encodeComponent(redirectUri)}'
        '&state=${Uri.encodeComponent(state)}';
    launchUrl(Uri.parse(url));
  }
}
