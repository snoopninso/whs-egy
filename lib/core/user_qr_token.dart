import 'package:uuid/uuid.dart';

String createUserQrToken() => const Uuid().v4();
