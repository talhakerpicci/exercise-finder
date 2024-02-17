import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'X_RapidAPI_Key', obfuscate: true)
  static final String rapidApiKey = _Env.rapidApiKey;
}
