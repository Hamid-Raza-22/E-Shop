import 'package:get/get.dart';

import '../../services/review_service.dart';

/// Review moderation queue.
class AdminReviewsController extends GetxController {
  AdminReviewsController({ReviewService? service})
      : _service = service ?? Get.find<ReviewService>();

  final ReviewService _service;

  static AdminReviewsController get to => Get.find<AdminReviewsController>();

  final RxList<ModeratedReview> _all = <ModeratedReview>[].obs;
  final RxBool _pendingOnly = true.obs;
  final RxnString _error = RxnString();

  bool get pendingOnly => _pendingOnly.value;

  String? get error => _error.value;

  int get pendingCount => _all.where((review) => !review.isApproved).length;

  List<ModeratedReview> get reviews => _pendingOnly.value
      ? _all.where((review) => !review.isApproved).toList()
      : _all.toList();

  @override
  void onInit() {
    super.onInit();
    _all.bindStream(_service.watchAll());
  }

  void setPendingOnly(bool value) => _pendingOnly.value = value;

  Future<bool> approve(ModeratedReview review) =>
      _withId(review, (id) => _service.setApproved(id, isApproved: true));

  Future<bool> unapprove(ModeratedReview review) =>
      _withId(review, (id) => _service.setApproved(id, isApproved: false));

  Future<bool> delete(ModeratedReview review) =>
      _withId(review, _service.delete);

  /// Reviews read from Firestore always carry an id; the nullable field only
  /// covers not-yet-created ones, which never reach the moderation queue.
  Future<bool> _withId(
    ModeratedReview review,
    Future<void> Function(String id) action,
  ) {
    final id = review.id;
    if (id == null) return Future.value(false);
    return _guard(() => action(id));
  }

  Future<bool> _guard(Future<void> Function() action) async {
    _error.value = null;
    try {
      await action();
      return true;
    } catch (exception) {
      _error.value = exception.toString();
      return false;
    }
  }
}
