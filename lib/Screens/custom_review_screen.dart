import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

/// Shows the review prompt as a non-dismissible bottom sheet.
///
/// [onClose] is called when the close button is tapped, after handling the response.
/// Use this callback to navigate away from the current screen.
///
/// If user taps "Yes" → sets flag and shows in-app review, then calls onClose
/// If user taps "No" → sets flag and shows dummy feedback, then calls onClose
/// If user taps close button without responding → flag is NOT set, just calls onClose
void showReviewPromptBottomSheet(BuildContext context, {required VoidCallback onClose}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return _ReviewPromptBottomSheet(onClose: onClose);
    },
  );
}

/// Bottom sheet widget for the review prompt
class _ReviewPromptBottomSheet extends StatelessWidget {
  final VoidCallback onClose;

  const _ReviewPromptBottomSheet({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button row
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                // Close without setting flag - user didn't respond
                Navigator.of(context).pop();
                onClose();
              },
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 28,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(height: 8),
          // Question text
          Text(
            'didYouLikeTheSession'.tr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // "Yes, loved it!" button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onPositiveResponse(onClose);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'yesLovedIt'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // "Not really" button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onNegativeResponse(context, onClose);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: theme.colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'notReally'.tr,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          // Extra bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// User liked the session - set flag, show in-app review, then call onClose
void _onPositiveResponse(VoidCallback onClose) {
  // Set the flag so we don't ask again
  globalController.userProfile.value.isShownCustomReviewDialogOnce = true;
  globalController.updateProfile();

  // Show the native in-app review dialog
  globalController.showReviewDialog();

  // Navigate away
  onClose();
}

/// User didn't like the session - set flag, show dummy feedback, then call onClose
void _onNegativeResponse(BuildContext context, VoidCallback onClose) {
  // Set the flag so we don't ask again
  // globalController.userProfile.value.isShownCustomReviewDialogOnce = true;
  // globalController.updateProfile();

  // Show dummy feedback bottom sheet
  _showDummyFeedbackBottomSheet(context, onClose: onClose);
}

/// Shows a dummy feedback bottom sheet with just a "Done" button
void _showDummyFeedbackBottomSheet(BuildContext context, {required VoidCallback onClose}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      final theme = Theme.of(context);

      return Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button row
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onClose();
                },
                icon: Icon(
                  Icons.close,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 28,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'thankYouFeedback'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onClose();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'feedbackDone'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            // Extra bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      );
    },
  );
}
