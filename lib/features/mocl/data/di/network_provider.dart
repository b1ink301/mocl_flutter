import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@riverpod
ApiClient apiClient(ref) => ApiClient();
