import 'package:http/http.dart';
import 'package:http/io_client.dart';

class GoogleHttpClient extends IOClient {
  final Map<String, String> _headers;
  GoogleHttpClient(this._headers) : super();
  @override
  Future<IOStreamedResponse> send(BaseRequest request) async {
    return super.send(request..headers.addAll(_headers));
  }

  @override
  Future<Response> head(Object url, {Map<String, String>? headers}) =>
      super.head(url as Uri, headers: headers?..addAll(_headers));
}
