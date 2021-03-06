part of core.data_handling.transfer;

enum Slug {
  auth,
  get,
  put,
  delete,
}

class RequestObject {
  final JSON jsonData;

  /// Either pass a complete [Map], or use an [emptyRequestMap] from `utils.dart`.
  /// It conains the default keys such as 'headers', 'auth', 'jwt' set to empty values.
  RequestObject(this.jsonData);

  String get jwtString => jsonData['headers']['auth']['jwt'];
  Slug get slug => jsonData['headers']['slug'];

  setSlug(Slug slug) => jsonData['headers']['slug'] = slug.string;

  setJwtString(String jwtString) =>
      jsonData['headers']['auth']['jwt'] = jwtString;

  setPayload(JSON payload) => jsonData['body']['payload'] = payload;
}

class ResponseObject {
  final JSON jsonData;
  final LighthouseException? error;

  const ResponseObject(this.jsonData, [this.error]);

  int get statusCode => jsonData['body']['status']['code'];
  String get statusMsg => jsonData['body']['status']['msg'];
  String get jwtString => jsonData['headers']['auth']['jwt'];
  JSON get payload => jsonData['body']['payload'];
}

class HttpClient {
  static late SatelliteStation _satelliteStation;
  static const bool _debugMode = false;
  static const String baseUrl =
      "https://infinitumlabsinc.editorx.io/lighthousecloud/_functions";

  static void init(SatelliteStation satStation) {
    _satelliteStation = satStation;
  }

  /// This test merely checks whether a connection can be established with the DB.
  ///
  /// When checking whether the user is offline, this method is called after
  static Future<bool> testConnection() async {
    _satelliteStation.obsSat.stream.add('testConnection');
    // FUTURE: use connectivity package to check the type of connection, so that
    // Synchroniser can throttle accordingly
    late bool result;
    try {
      final response = await io.InternetAddress.lookup('example.com');
      if (response.isNotEmpty) {
        result = true;
      }
    } on io.SocketException catch (_) {
      result = false;
    }
    return result;
  }

  static void deinit() {}

  static Future<ResponseObject> get(RequestObject requestObject) async {
    return handleResponse(
      jsonDecode(
        await HttpRequest.requestCrossOrigin('$baseUrl/test', method: 'GET'),
      ),
    );
  }

  /// Handles the raw response received, processing the error if there is one.
  ///
  /// The error is included when creating the [ResponseObject], and is then accessed
  /// by the method that called the [get] request in the first place, through
  /// [ResponseObject.error]
  static ResponseObject handleResponse(JSON rawResponse) {
    return ResponseObject(rawResponse);
  }

  static Future<ResponseObject> batchUpdate(RequestObject requestObject) async {
    /* if (_debugMode) return const ResponseObject({});
    return _httpClient.get(
      Uri.parse(baseUrl + 'auth'), // requestObject.slug.string
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${requestObject.jwtString}',
      },
    ).then((http.Response response) {
      return ResponseObject(
        jsonDecode(response.body),
      );
    }); */
    return ResponseObject({});
  }
}
