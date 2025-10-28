// Copyright (c) 2025 Shahadat Hosen Nishan. All rights reserved.
//
// This software is licensed under the MIT License.
// See the LICENSE file in the project root for details.
//
// Find me at: https://github.com/nishan979
// https://www.linkedin.com/in/nishan979/
// nishanshish@gmail.com

import 'dart:async';
import 'package:get/get.dart';




class UiUtils {
  static void safeDismiss() {
    
    
    
    
    
    void tryCloseDialog() {
      try {
        
        
        
        if (Get.isDialogOpen == true && Get.isSnackbarOpen != true) {
          Get.back();
        }
      } on AssertionError catch (ae) {
        final msg = ae.message?.toString() ?? '';
        if (!msg.contains('Cannot remove entry from a disposed snackbar')) {
          
        }
      } catch (_) {}
    }

    
    
    
    
    try {
      runZonedGuarded(
        () {
          scheduleMicrotask(() {
            tryCloseDialog();
          });
        },
        (error, stack) {
          
          if (error is AssertionError) {
            final msg = error.message?.toString() ?? '';
            if (!msg.contains('Cannot remove entry from a disposed snackbar')) {
              
              
            }
          } else {
            
          }
        },
      );
    } catch (_) {}

    
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
          
        },
      );
    } catch (_) {}
  }

  
  
  
  
  static void showSnackbar(String title, String message) {
    Future.microtask(() async {
      try {
        
        
        if (Get.isSnackbarOpen == true) {
          await Future.delayed(const Duration(milliseconds: 350));
        }
        Get.snackbar(title, message);
      } catch (e) {
        
      }
    });
  }
}
