import 'package:dns/dns.dart';
import 'package:universal_io/io.dart';

/// Class handling app-connectivity
class Connectivity {
  /// DNS-Client used to check connectivity
  var client;

  /// Constructor for the connectivity class
  Connectivity({this.client});

  /// Function checking the online status of the app
  Future<bool> isOnline() async {
    try {
      client ??= UdpDnsClient(remoteAddress: InternetAddress("8.8.8.8"));
      final packet = await client.lookupPacket('google.com');
      if (packet.isResponse && packet.answers[0].name == 'google.com') {
        return true;
      }
    } on Exception
    catch (_) {
      return false;
    }
    return false;
  }
}