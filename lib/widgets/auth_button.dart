import 'package:giftor/constants_and_methods.dart';

import '../my_packages/my_packages.dart';

class AuthButton extends StatefulWidget {
  final isLoading;
  final Color btnColor;
  final String btnText;
  final VoidCallback onTap;

  AuthButton({
    this.isLoading = false,
    this.btnColor = const Color.fromARGB(255, 11, 137, 162),
    required this.btnText,
    required this.onTap,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _startSpinner = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 50.0,
      width: widget.isLoading ? 50.0 : MediaQuery.of(context).size.width * 0.80,
      duration: const Duration(milliseconds: 500),
      onEnd: () {
        if (widget.isLoading) {
          setState(() => _startSpinner = true);
        } else {
          setState(() => _startSpinner = false);
        }
      },
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: widget.btnColor,
            shape: RoundedRectangleBorder(
              borderRadius: widget.isLoading
                  ? BorderRadius.circular(25.0)
                  : kDefaultBorderRadius,
            ),
            elevation: 12.0),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: FittedBox(
                child: _startSpinner
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                        constraints:
                            BoxConstraints(minHeight: 40, minWidth: 40),
                      )
                    : Text(
                        widget.btnText,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
        onPressed: _startSpinner ? () {} : widget.onTap,
      ),
    );
  }
}
