import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'definitions.dart';

import '../helpers/utils.dart' as utils;

typedef Future<String> GetValidToken();

abstract class BaseApiService {
  Future<T> get<T>({
    @required String apiUrl,
    @required CreateModelFromJson parser,
    Map<String, String> header,
    Map<String, String> query,
    bool needToken = false,
    bool needDecodeOnBackground = false,
  });
  Future<T> post<T>({
    @required String apiUrl,
    @required CreateModelFromJson parser,
    Map<String, String> header,
    Map<String, dynamic> body,
    bool needToken = false,
    bool needDecodeOnBackground = false,
  });
  Future<T> upload<T>({
    @required String apiUrl,
    @required CreateModelFromJson parser,
    @required List<FileInfo> files,
    Map<String, String> header,
    bool needToken = false,
    bool needDecodeOnBackground = false,
  });
  Future<T> uploadToUri<T>({
    @required Uri uri,
    @required CreateModelFromJson parser,
    @required List<FileInfo> files,
    Map<String, String> header,
    Map<String, String> fields,
    bool needDecodeOnBackground = false,
    bool parserHeader=false,
  });
}

class ApiService implements BaseApiService {
  final String authority;
  final String subPath;
  final int connectionTO;
  final bool isHTTPS;
  final PublishSubject<ErrorInfo> errorSubject;
  final GetValidToken _getValidToken;

  ApiService({
    @required GetValidToken getValidToken,
    @required this.authority,
    @required this.subPath,
    this.connectionTO = 20,
    this.isHTTPS = false,
    this.errorSubject,
  }): this._getValidToken = getValidToken;

  @override
  Future<T> get<T>({
    @required String apiUrl,
    @required CreateModelFromJson parser,
    Map<String, String> header,
    Map<String, String> query,
    bool needToken = false,
    bool needDecodeOnBackground = false,
  }) async {
    // print("GET Start - $apiUrl");
    Uri uri = _createUri(authority, subPath + apiUrl, query);
    http.Response response = await http.get(uri,
      headers: await _buildHeader(header, needToken, apiUrl),
    ).timeout(Duration(seconds: connectionTO));
    var result = await _responseHandle(response, parser, needDecodeOnBackground);
    // print("GET End - $apiUrl");
    return result;
  }

  @override
  Future<T> post<T>({
    @required String apiUrl,
    @required CreateModelFromJson parser,
    Map<String, String> header,
    Map<String, dynamic> body,
    bool needToken = false,
    bool needDecodeOnBackground = false,
  }) async {
    // print("POST Start - $apiUrl");
    Uri uri = _createUri(authority, subPath + apiUrl);
    String stringBody = body == null ? "": json.encode(body);

    Map<String, String> candidateHeader = Map();
    if (header != null) {
      candidateHeader.addAll(header);
    }
    candidateHeader.addAll({"Content-Type":"application/json",});

    http.Response response = await http.post(uri,
      headers: await _buildHeader(candidateHeader, needToken, apiUrl),
      body: stringBody,
    ).timeout(Duration(seconds: connectionTO));
    var result = await _responseHandle(response, parser, needDecodeOnBackground);
    // print("POST End - $apiUrl");
    return result;
  }

  @override
  Future<T> upload<T>({
    @required String apiUrl,
    @required CreateModelFromJson parser,
    @required List<FileInfo> files,
    Map<String, String> header,
    bool needToken = false,
    bool needDecodeOnBackground = false,
  }) async {
    print("UPLOAD Start - $apiUrl");

    Uri uri = _createUri(authority, subPath + apiUrl);
    return uploadToUri<T>(
      uri: uri,
      parser: parser,
      files: files,
      header: await _buildHeader(header, needToken, apiUrl),
      needDecodeOnBackground: needDecodeOnBackground
      );
  }

  Future<T> uploadToUri<T>({
    @required Uri uri,
    @required CreateModelFromJson parser,
    @required List<FileInfo> files,
    Map<String, String> header,
    Map<String, String> fields,
    bool needDecodeOnBackground = false,
    bool parserHeader=false,
  }) async {
    var request = http.MultipartRequest("POST", uri);
    if (header != null) {
      request.headers.addAll(header);
    }
    if (fields != null) {
      request.fields.addAll(fields);
    }

    for (FileInfo fileInfo in files) {
      String fileName = basename(fileInfo.file.path);
      MediaType type = MediaType.parse(utils.getMediaType(fileName));
      request.files.add(
          http.MultipartFile(
            fileInfo.field,
            http.ByteStream(DelegatingStream.typed(fileInfo.file.openRead())),
            await fileInfo.file.length(),
            filename: fileName,
            contentType: type,
          )
      );
    }

    http.StreamedResponse streamedResponse = await request.send().timeout(const Duration(seconds: 20));
    http.Response response = await http.Response.fromStream(streamedResponse);
    var result = await _responseHandle(response, parser, needDecodeOnBackground, parserHeader:parserHeader);
    return result;
  }

  // utility methods
  Future<Map<String, String>> _buildHeader(Map<String, String> header, bool needToken, String apiUrl) async {
    Map<String, String> candidateHeader = Map();
    if (header != null) {
      candidateHeader.addAll(header);
    }
    if (needToken) {
      final token = await _getValidToken();
      if (token == null) {
        _throwError(message: "$apiUrl error: have no token");
      }
      else {
        candidateHeader.addAll({"Authorization":token,});
      }
    }
    return candidateHeader;
  }

  Future<dynamic> _responseHandle(http.Response response, CreateModelFromJson parser, bool needDecodeOnBackground, {bool parserHeader=false}) async {
    if (response.statusCode == 400 || response.statusCode == 401) {
      _throwError(code: response.statusCode, message: "Authentication failed");
    }
    else if (response.statusCode < 200 || response.statusCode > 401) {
      _throwError(code: response.statusCode, message: json.decode(response.body)["error"]["message"]);
    }
    else {
      if (parserHeader) {
        return parser(response.headers);
      }
      Map<String, dynamic> map;
      if (needDecodeOnBackground) {
        map = await compute<String, Map<String, dynamic>>(_decode, response.body);
      }
      else {
        map = _decode(response.body);
      }
      return parser(map);
    }
  }

  void _throwError({int code, String message}) {
    if (errorSubject != null) {
      errorSubject.add(ErrorInfo(code: code, message: message));
    }
    throw Exception(message);
  }

  Uri _createUri(String authority, String unencodedPath, [Map<String, String> queryParameters]) {
    return isHTTPS?
      Uri.https(authority, unencodedPath, queryParameters):
      Uri.http(authority, unencodedPath, queryParameters);
  }

}

Map<String, dynamic> _decode(String body) {
  return json.decode(body);
}
