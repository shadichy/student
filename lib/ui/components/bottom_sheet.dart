import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

ShapeBorder _m3BottomSheetShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
);

Future<T?> showM3ModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool bounce = false,
  bool expand = false,
  AnimationController? secondAnimation,
  Curve? animationCurve,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  Duration? duration,
  RouteSettings? settings,
  double? closeProgressThreshold,
}) async {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));
  ThemeData theme = Theme.of(context);
  ColorScheme colorScheme = theme.colorScheme;
  return await showMaterialModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor,
    elevation: elevation,
    clipBehavior: clipBehavior,
    barrierColor: barrierColor,
    bounce: bounce,
    expand: expand,
    secondAnimation: secondAnimation,
    animationCurve: animationCurve,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    duration: duration,
    settings: settings,
    closeProgressThreshold: closeProgressThreshold,
    shape: shape ?? _m3BottomSheetShape,
    builder: (context) => Material(
      shape: shape ?? _m3BottomSheetShape,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 22),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(
              height: 1,
              width: MediaQuery.of(context).size.width,
            ),
            child
          ],
        ),
      ),
    ),
  );
}
