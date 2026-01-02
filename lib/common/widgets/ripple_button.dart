import 'package:Vfix4u/utils/core_export.dart';

class RippleButton extends StatelessWidget {
  const RippleButton({super.key, required this.onTap, this.borderRadius = 5});
  final GestureTapCallback onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        splashColor: const Color(0xffFEFEFE).withValues(alpha: 0.1),
        highlightColor: const Color(0xffFEFEFE).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
