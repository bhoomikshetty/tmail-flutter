import 'package:core/core.dart';
import 'package:core/presentation/utils/app_toast.dart';
import 'package:device_info/device_info.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmail_ui_user/features/email/data/local/html_analyzer.dart';

class CoreBindings extends Bindings {

  @override
  Future dependencies() async {
    await _bindingSharePreference();
    _bindingAppImagePaths();
    _bindingResponsiveManager();
    _bindingKeyboardManager();
    _bindingTransformer();
    _bindingToast();
    _bindingDeviceManager();
  }

  void _bindingAppImagePaths() {
    Get.put(ImagePaths());
  }

  void _bindingResponsiveManager() {
    Get.put(ResponsiveUtils());
  }

  Future _bindingSharePreference() async {
    await Get.putAsync(() async => await SharedPreferences.getInstance(), permanent: true);
  }

  void _bindingKeyboardManager() {
    Get.put(KeyboardUtils());
  }

  void _bindingTransformer() {
    Get.put(HtmlAnalyzer());
  }

  void _bindingToast() {
    Get.put(AppToast());
  }

  void _bindingDeviceManager() {
    Get.put(DeviceInfoPlugin());
    Get.put(DeviceManager(Get.find<DeviceInfoPlugin>()));
  }
}