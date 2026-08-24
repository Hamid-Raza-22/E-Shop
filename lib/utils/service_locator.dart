import 'package:get/get.dart';

/// Resolves a dependency that may not be registered at all.
///
/// `Get.isRegistered` only knows about eagerly `put` instances, so it reports
/// `false` for the Firestore services in `InitialBindings` until something has
/// resolved them once — `Get.isPrepared` is what covers `lazyPut`. Tests run
/// without Firebase and therefore without those services, so every storefront
/// call site has to tolerate a missing service instead of throwing.
T? serviceOrNull<T>() {
  if (!Get.isRegistered<T>() && !Get.isPrepared<T>()) return null;
  try {
    return Get.find<T>();
  } catch (_) {
    return null;
  }
}
