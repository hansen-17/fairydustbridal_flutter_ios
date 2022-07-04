import 'package:flutter/material.dart';
import 'size_util.dart';

class LoadingButton extends StatefulWidget {
  final TextButton textButton;
  LoadingButton({required this.textButton});

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  late TextButton textButton;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    textButton = widget.textButton;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : execute,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 2.h,
                      height: 2.h,
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    Visibility(
                      child: textButton.child!,
                      visible: false,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                    ),
                  ],
                )
              : textButton.child!,
        ],
      ),
      style: textButton.style,
    );
  }

  Future<void> execute() async {
    setState(() => isLoading = true);
    await (textButton.onPressed as Future<void> Function())();
    setState(() => isLoading = false);
  }
}
