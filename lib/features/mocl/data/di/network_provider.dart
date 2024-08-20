import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient.getInstance());
