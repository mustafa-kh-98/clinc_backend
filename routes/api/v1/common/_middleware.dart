import 'package:clinic/provider/common_provider.dart';
import 'package:dart_frog/dart_frog.dart';

CommonProvider? _commonProvider;

Handler middleware(Handler handler) {
  return handler.use(
    provider<CommonProvider>(
      (context) => _commonProvider ??= CommonProvider(),
    ),
  );
}
