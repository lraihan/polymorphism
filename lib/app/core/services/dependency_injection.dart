import 'package:get/get.dart';
import 'package:project_master_template/app/core/services/connectivity_service.dart';
import 'package:project_master_template/app/core/services/logger_service.dart';
import 'package:project_master_template/app/data/service/services.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Core Services
    await Get.putAsync(() => StorageService().init(), permanent: true);
    Get..put(LoggerService(), permanent: true)
    ..put(ConnectivityService(), permanent: true)
    ..put(ApiService(), permanent: true);
  }
}

extension StorageServiceInit on StorageService {
  Future<StorageService> init() async {
    await onInit();
    return this;
  }
}
