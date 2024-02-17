import 'package:exercise_finder/services/hive_service.dart';
import 'package:injectable/injectable.dart';

@module
abstract class HiveServiceModule {
  @preResolve
  Future<HiveService> get hiveService async {
    final hiveService = HiveService();
    await hiveService.init();
    return hiveService;
  }
}
