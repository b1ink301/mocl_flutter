import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';

class SignInUseCase {
  final GoogleDriveRepository repository;

  SignInUseCase(this.repository);

  Future<void> call() {
    return repository.signIn();
  }
}
