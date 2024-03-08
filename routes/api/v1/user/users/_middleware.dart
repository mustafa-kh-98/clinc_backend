import 'package:clinic/provider/user_provider.dart';
import 'package:dart_frog/dart_frog.dart';

UserProviderImpl? _userProviderImpl;

Handler middleware(Handler handler) {
  return handler.use(
    provider<UserProviderImpl>(
          (context) => _userProviderImpl ??= UserProviderImpl(),
    ),
  );
}
