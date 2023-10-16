import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String errorDetails;
  final String errorTitle;
  final int statusCode;
  const ErrorDialog(
      {Key? key,
      required this.icon,
      required this.errorDetails,
      required this.errorTitle,
      required this.color,
      required this.statusCode})
      : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  bool showDetails = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.color,
                  size: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Flexible(
                  child: Text(
                    widget.errorTitle,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    if (widget.statusCode == 401 || widget.statusCode == 417) {
                      Navigator.pushNamed(context, "/");
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("ok"),
                ),
                const SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                  child: Text(
                    "show Details",
                    style: TextStyle(color: showDetails ? Colors.red : null),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              ],
            ),
            if (showDetails)
              Flexible(
                child: Text(
                  widget.errorDetails,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
