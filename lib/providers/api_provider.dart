import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/services/api/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
