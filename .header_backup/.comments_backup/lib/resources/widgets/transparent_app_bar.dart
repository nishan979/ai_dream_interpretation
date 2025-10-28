import 'package:ai_dream_interpretation/resources/widgets/circular_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final bool showBackButton;

  const TransparentAppBar({
    super.key,
    this.automaticallyImplyLeading = false,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Align(
        alignment: Alignment.centerLeft,
        child: showBackButton
            ? const CircularBackButton()
            : const SizedBox.shrink(),
      ),
      titleSpacing: 16.w,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
