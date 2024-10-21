import 'dart:convert';

import 'package:cli_server/globals.dart';
import 'package:cli_server/repos.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}


