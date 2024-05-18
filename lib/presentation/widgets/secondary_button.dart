import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String opsi;
  final String text;
  final bool isSelected;
  final VoidCallback? onPressed;

  const SecondaryButton({
    super.key,
    required this.opsi,
    required this.text,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: SizedBox(
        width: queryData.size.width,
        height: queryData.size.width * 1 / 7,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.tertiary
                : Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: queryData.size.width * 1 / 8,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      opsi,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: queryData.size.width * 1 / 1.9,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}