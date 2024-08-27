import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';

final localeCodeProvider = StateProvider<String>((ref) => 'ko');
