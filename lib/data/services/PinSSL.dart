import 'package:http_certificate_pinning/http_certificate_pinning.dart';

Future checkSSL(String url, List<String> allowedSHAFingerprints) async {
  try {
    final secure = await HttpCertificatePinning.check(
      serverURL: url,
      headerHttp: Map(),
      sha: SHA.SHA256,
      allowedSHAFingerprints: allowedSHAFingerprints,
      timeout: 50,
    );

    if (secure.contains("CONNECTION_SECURE")) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
