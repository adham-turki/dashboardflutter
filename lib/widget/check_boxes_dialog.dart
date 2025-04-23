import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExportCheckBoxesDialog extends StatefulWidget {
  final Function(
    bool dateBoolVal,
    bool voucherBoolVal,
    bool voucherNumBoolVal,
    bool statusBoolVal,
    bool accountBoolVal,
    bool referenceBoolVal,
    bool currency,
    bool debitBoolVal,
    bool cridetBoolVal,
    bool dibcBoolVal,
    bool cibcBoolVal,
    bool commentsBoolVal,
  ) onFilter;
  const ExportCheckBoxesDialog({
    super.key,
    required this.onFilter,
  });

  @override
  State<ExportCheckBoxesDialog> createState() => _ExportCheckBoxesDialogState();
}

class _ExportCheckBoxesDialogState extends State<ExportCheckBoxesDialog> {
  double height = 0;
  double width = 0;
  late AppLocalizations _locale;
  bool dateBoolVal = true;
  bool voucherBoolVal = true;
  bool voucherNumBoolVal = true;
  bool statusBoolVal = true;
  bool accountBoolVal = true;
  bool referenceBoolVal = true;
  bool currency = true;
  bool debitBoolVal = true;
  bool cridetBoolVal = true;
  bool dibcBoolVal = true;
  bool cibcBoolVal = true;
  bool commentsBoolVal = true;

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context)!;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: SizedBox(
        height: height * 0.5,
        width: width * 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: height * 0.07,
              child: Center(
                child: Text(
                  _locale.chooseColumns,
                  style: TextStyle(
                      fontSize: height * 0.025, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.date),
                            Checkbox(
                              value: dateBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  dateBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.voucher),
                            Checkbox(
                              value: voucherBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  voucherBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.voucherNum),
                            Checkbox(
                              value: voucherNumBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  voucherNumBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.status),
                            Checkbox(
                              value: statusBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  statusBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.account),
                            Checkbox(
                              value: accountBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  accountBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.reference),
                            Checkbox(
                              value: referenceBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  referenceBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.currency),
                            Checkbox(
                              value: currency,
                              onChanged: (bool? value) {
                                setState(() {
                                  currency = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.debit),
                            Checkbox(
                              value: debitBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  debitBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.credit),
                            Checkbox(
                              value: cridetBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  cridetBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.comments),
                            Checkbox(
                              value: commentsBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  commentsBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.dibc),
                            Checkbox(
                              value: dibcBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  dibcBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_locale.cibc),
                            Checkbox(
                              value: cibcBoolVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  cibcBoolVal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: SizedBox(
            width: width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.08, height * 0.06),
                        backgroundColor: Colors.green.shade900),
                    onPressed: () {
                      widget.onFilter(
                          dateBoolVal,
                          voucherBoolVal,
                          voucherNumBoolVal,
                          statusBoolVal,
                          accountBoolVal,
                          referenceBoolVal,
                          currency,
                          debitBoolVal,
                          cridetBoolVal,
                          dibcBoolVal,
                          cibcBoolVal,
                          commentsBoolVal);
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      _locale.ok,
                      style: TextStyle(fontSize: height * 0.02),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.08, height * 0.06),
                        backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      _locale.cancel,
                      style: TextStyle(fontSize: height * 0.02),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }
}
