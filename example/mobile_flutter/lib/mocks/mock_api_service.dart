
import 'package:rxdart/rxdart.dart';

import '../services/api_service.dart';
import '../services/definitions.dart';

class MockApiService implements BaseApiService {
  final PublishSubject<ErrorInfo> errorSubject;

  MockApiService({
    this.errorSubject
  });

  @override
  Future<T> get<T>({String apiUrl, parser, Map<String, String> header, Map<String, String> query, bool needToken = false, bool needDecodeOnBackground = false}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (apiUrl == 'upload') {
      return {
        'url': 'a1sdf.org',
        'fields': {}
      } as dynamic;
    }
    return null;
  }

  @override
  Future<T> post<T>({String apiUrl, parser, Map<String, String> header, Map<String, dynamic> body, bool needToken = false, bool needDecodeOnBackground = false}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (apiUrl == 'hello') {
      return null;
    }
    return null;
  }

  @override
  Future<T> upload<T>({String apiUrl, parser, List<FileInfo> files, Map<String, String> header, bool needToken = false, bool needDecodeOnBackground = false}) {
    // TODO: implement upload
    return null;
  }

  @override
  Future<T> uploadToUri<T>({Uri uri, CreateModelFromJson parser, List<FileInfo> files, Map<String, String> header,
    Map<String, String> fields, bool needDecodeOnBackground = false, bool parserHeader = false}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (uri.path == 'a1sdf.org') {
      return files[0].file.path as dynamic;
    }
    return null;
  }

}
