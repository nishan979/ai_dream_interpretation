import 'dart:async';
import 'package:get/get.dart';
// (removed unused foundation import)

/// Small utility to safely dismiss dialogs and snackbars without
/// tripping GetX internal assertion races.
class UiUtils {
  static void safeDismiss() {
    // Always attempt to close the dialog/snackbar. Sometimes callers call
    // safeDismiss immediately after showing a dialog; the dialog may not
    // have been fully registered in Get yet which can leave the spinner
    // visible. We'll schedule a few close attempts (microtask + short
    // delayed retries) and swallow any errors.
    void tryCloseDialog() {
      try {
        // Avoid calling Get.back() if a snackbar is currently open; calling
        // back while a snackbar is being removed can race and cause
        // "Cannot remove entry from a disposed snackbar" assertions.
        if (Get.isDialogOpen == true && Get.isSnackbarOpen != true) {
          Get.back();
        }
      } on AssertionError catch (ae) {
        final msg = ae.message?.toString() ?? '';
        if (!msg.contains('Cannot remove entry from a disposed snackbar')) {
          // ignore other assertion messages
        }
      } catch (_) {}
    }

    // Immediate microtask attempt. Wrap in runZonedGuarded to catch
    // asynchronous assertion errors thrown by Get internals (e.g. "Cannot
    // remove entry from a disposed snackbar") which can otherwise crash the
    // app when they occur in a later microtask.
    try {
      runZonedGuarded(
        () {
          scheduleMicrotask(() {
            tryCloseDialog();
          });
        },
        (error, stack) {
          // Swallow snackbar/disposed assertion errors; log others in debug.
          if (error is AssertionError) {
            final msg = error.message?.toString() ?? '';
            if (!msg.contains('Cannot remove entry from a disposed snackbar')) {
              // other assertion; log during debug
              // (debug print removed)
            }
          } else {
            // (debug print removed)
          }
        },
      );
    } catch (_) {}

    // Short delayed retries in case the dialog registers a few ms later.
    try {
      runZonedGuarded(
        () {
          Future.delayed(const Duration(milliseconds: 50), () {
            tryCloseDialog();
          });
          Future.delayed(const Duration(milliseconds: 250), () {
            tryCloseDialog();
          });
        },
        (error, stack) {
          // Swallow the disposed-snackbar assertion and log others in debug.
        },
      );
    } catch (_) {}
  }

  /// Show a snackbar in a safe way to avoid racing with the internal Get
  /// snackbar queue which may throw assertions when removing disposed
  /// entries. This schedules the snackbar show in a microtask and waits a
  /// short time if another snackbar is currently open.
  static void showSnackbar(String title, String message) {
    Future.microtask(() async {
      try {
        // If a snackbar is currently shown, give it a short time to close
        // to avoid racing internal disposal.
        if (Get.isSnackbarOpen == true) {
          await Future.delayed(const Duration(milliseconds: 350));
        }
        Get.snackbar(title, message);
      } catch (e) {
        // (debug print removed)
      }
    });
  }
}
