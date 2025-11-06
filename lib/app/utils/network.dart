import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<List<dio.MultipartFile>> getMultipartFilesFromXfiles(
    List<XFile> xfiles) async {
  List<dio.MultipartFile> multiPartFileList = [];

  for (XFile file in xfiles) {
    multiPartFileList.add(dio.MultipartFile.fromBytes(
      await file.readAsBytes(),
      filename: file.path.split('/').last,
    ));
  }
  return multiPartFileList;
}

String generateCurlCommandFromHttpMultipart(http.MultipartRequest request) {
  // Start building the cURL command with the HTTP method and URL
  final curlCommand =
      StringBuffer('curl -X ${request.method} \'${request.url.toString()}\'');

  // Add headers to the cURL command
  request.headers.forEach((key, value) {
    curlCommand.write(' -H \"$key: $value\"');
  });

  // Add fields to the cURL command
  request.fields.forEach((key, value) {
    curlCommand.write(' -F \"$key=$value\"');
  });

  // Add files to the cURL command
  for (var file in request.files) {
    curlCommand.write(' -F \"${file.field}=@${file.filename}\"');
  }

  return curlCommand.toString();
}

String generateCurlCommandHttp(http.Request request) {
  // Start building the cURL command with the HTTP method and URL
  final curlCommand =
      StringBuffer('curl -X ${request.method} \'${request.url.toString()}\'');

  // Add headers to the cURL command
  request.headers.forEach((key, value) {
    curlCommand.write(' -H \"$key: $value\"');
  });

  // Add body data to the cURL command if present
  if (request.body.isNotEmpty) {
    // Escape single quotes in the body data to avoid breaking the shell command
    final escapedBody = request.body.replaceAll('\'', '\\\'');
    curlCommand.write(' -d \'$escapedBody\'');
  }

  return curlCommand.toString();
}

String generateCurlCommandDio(RequestOptions request) {
  final buffer =
      StringBuffer('curl -X ${request.method} \'${request.uri.toString()}\'');

  // Add headers to the cURL command
  request.headers.forEach((key, value) {
    buffer.write(' -H "$key: $value"');
  });

  // Add body if it's a POST or PUT request
  if (request.data != null) {
    // Convert the request body to JSON
    final body = jsonEncode(request.data);
    buffer.write(' -d \'$body\'');
  }
  List<String> list = buffer.toString().split('-F');
  list.forEach((item) => debugPrint(item));

  return buffer.toString();
}

String generateCurlCommandFromDioFormRequest(
    {required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? formData,
    List<MapEntry<String, MultipartFile>>? files}) {
  // Start with the basic curl command
  String curlCommand = 'curl -X POST $url';

  // Add headers to the curl command
  if (headers != null && headers.isNotEmpty) {
    headers.forEach((key, value) {
      curlCommand += ' -H "$key: $value"';
    });
  }

  // Add form data fields
  if (formData != null && formData.isNotEmpty) {
    formData.forEach((key, value) {
      if (value is String || value is int || value is double) {
        curlCommand += ' -F "$key=$value"';
      } else {
        throw ArgumentError('Unsupported form data type: ${value.runtimeType}');
      }
    });
    files?.forEach((mapEntry) {
      curlCommand +=
          ' -F "${mapEntry.key}=@${mapEntry.value.length};filename=${mapEntry.value.filename}"';
    });
  }

  List<String> parts = curlCommand.toString().split('-F');
  parts.forEach((value) {
    print(value);
  });

  return curlCommand;
}

// Helper class to represent a file
