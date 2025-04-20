import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/responsive.dart';
import '../../../utils/constants/styles.dart';
import '../../../utils/func/converters.dart';
import 'total_sales_result.dart';

class TotalSalesModel {
  String? code;
  String? name;
  double? inQnty;
  double? outQnty;
  double? netSold;
  double? debit;
  double? credit;
  double? totalAmount;
  double? count;
  String? stockBarCode;
  double? curQty;
  TotalSalesModel(this.code, this.name, this.inQnty, this.outQnty, this.netSold,
      this.debit, this.credit, this.totalAmount, this.curQty);

  TotalSalesModel.fromJson(Map<String, dynamic> totalSales) {
    code = totalSales['code'].toString() == "null"
        ? ""
        : totalSales['code'].toString();
    name = totalSales['name'].toString() == "null"
        ? ""
        : totalSales['name'].toString();
    inQnty =
        totalSales['inQnty'].toString() == "null" ? 0.0 : totalSales['inQnty'];
    outQnty = totalSales['outQnty'].toString() == 'null'
        ? 0.0
        : totalSales['outQnty'];

    netSold = totalSales['netSold'].toString() == "null"
        ? 0.0
        : totalSales['netSold'];
    debit =
        totalSales['debit'].toString() == 'null' ? 0.0 : totalSales['debit'];
    credit =
        totalSales['credit'].toString() == "null" ? 0.0 : totalSales['credit'];
    totalAmount = totalSales['totalAmount'].toString() == 'null'
        ? 0.0
        : totalSales['totalAmount'];
    count =
        totalSales['count'].toString() == "null" ? 0.0 : totalSales['count'];
    stockBarCode = totalSales['stockBarCode'].toString() == "null"
        ? ""
        : totalSales['stockBarCode'];
    curQty =
        totalSales['curQty'].toString() == "null" ? 0.0 : totalSales['curQty'];
  }

  PlutoRow toPluto(int counter) {
    final Map<String, PlutoCell> totalSales = <String, PlutoCell>{};
    totalSales['code'] = PlutoCell(value: code ?? "");
    totalSales['name'] = PlutoCell(value: name ?? "");
    totalSales['inQnty'] = PlutoCell(value: inQnty ?? 0);
    totalSales['curQty'] = PlutoCell(value: curQty ?? 0);
    totalSales['outQnty'] = PlutoCell(value: outQnty ?? 0);
    totalSales['netSold'] = PlutoCell(value: netSold ?? 0);
    totalSales['debit'] = PlutoCell(value: debit ?? 0);
    totalSales['credit'] = PlutoCell(value: credit ?? 0);
    totalSales['totalAmount'] = PlutoCell(value: totalAmount ?? 0);
    totalSales['count'] = PlutoCell(value: count ?? 0);
    totalSales['stockBarCode'] = PlutoCell(value: stockBarCode ?? "");
    totalSales['counter'] = PlutoCell(value: counter);
    return PlutoRow(cells: totalSales);
  }

  static List<PlutoColumn> getColumns(AppLocalizations localizations,
      TotalSalesResult? reportResult, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // int numberOfColumns = 4;
    // double width *0.15 = totalWidth / numberOfColumns;
    bool isDesktop = Responsive.isDesktop(context);
    List<PlutoColumn> list = [
      PlutoColumn(
        title: '#',
        field: 'counter',
        type: PlutoColumnType.text(),
        backgroundColor: columnColors,
        width: width * 0.05,
        // footerRenderer: (context) {
        //   return footerRendererPrice(context, traficResultModel.date ?? "");
        // },
      ),
      // PlutoColumn(
      //   title: localizations.code,
      //   field: "code",
      //   type: PlutoColumnType.text(),
      //   renderer: (rendererContext) {
      //     return Tooltip(
      //       message: rendererContext.cell.value,
      //       child: Text(
      //         rendererContext.cell.value.toString(),
      //         style: const TextStyle(fontSize: 10),
      //         textAlign: TextAlign.center,
      //         overflow: TextOverflow.ellipsis,
      //       ),
      //     );
      //   },
      //   width: isDesktop ? width * 0.09 : width * 0.3,
      //   backgroundColor: columnColors,
      // ),

      PlutoColumn(
        title: localizations.stock,
        field: "name",
        type: PlutoColumnType.text(),
        width: isDesktop ? width * 0.13 : width * 0.3,
        renderer: (rendererContext) {
          return Tooltip(
            message: rendererContext.cell.value,
            child: Text(
              rendererContext.cell.value.toString(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          );
        },
        backgroundColor: columnColors,
      ),
      PlutoColumn(
        title: localizations.barCode,
        field: 'stockBarCode',
        type: PlutoColumnType.text(),
        backgroundColor: columnColors,
        width: width * 0.08,
        // footerRenderer: (context) {
        //   return footerRendererPrice(context, traficResultModel.date ?? "");
        // },
      ),
      PlutoColumn(
        title: localizations.returnQty,
        field: "inQnty",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.07 : width * 0.3,
        backgroundColor: columnColors,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.inQnty!);
              }
            : (rendererContext) {
                return footerRenderer(rendererContext, 0);
              },
      ),
      PlutoColumn(
        title: localizations.returnQty,
        field: "curQty",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.07 : width * 0.3,
        backgroundColor: columnColors,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.curQty!);
              }
            : (rendererContext) {
                return footerRenderer(rendererContext, 0);
              },
      ),
      PlutoColumn(
        title: localizations.salesQty,
        field: "outQnty",
        type: PlutoColumnType.number(),
        width: isDesktop ? width * 0.1 : width * 0.3,
        // renderer: currencyRenderer,
        backgroundColor: columnColors,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRenderer(
                    rendererContext, reportResult.outQnty!);
              }
            : (rendererContext) {
                return footerRenderer(rendererContext, 0);
              },
      ),
      PlutoColumn(
        title: localizations.netSalesQty,
        field: "netSold",
        type: PlutoColumnType.currency(
          name: '(ILS) ',
          negative: true,
        ),
        width: isDesktop ? width * 0.1 : width * 0.3,
        renderer: currencyRenderer,
        backgroundColor: columnColors,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRendererPrice(
                    rendererContext, reportResult.netSold!);
              }
            : (rendererContext) {
                return footerRenderer(rendererContext, 0);
              },
      ),
      PlutoColumn(
        title: localizations.returnAmount,
        field: "debit",
        type: PlutoColumnType.currency(
          name: '(ILS) ',
          negative: true,
        ),
        renderer: currencyRenderer,
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: columnColors,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRendererPrice(
                    rendererContext, reportResult.debit!);
              }
            : (rendererContext) {
                return footerRenderer(rendererContext, 0);
              },
      ),
      PlutoColumn(
        title: localizations.salesAmount,
        field: "credit",
        type: PlutoColumnType.currency(
          name: '(ILS) ',
          negative: true,
        ),
        width: isDesktop ? width * 0.1 : width * 0.3,
        backgroundColor: columnColors,
        renderer: currencyRenderer,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRendererPrice(
                    rendererContext, reportResult.credit!);
              }
            : (rendererContext) {
                return footerRenderer(rendererContext, 0);
              },
      ),
      PlutoColumn(
        title: localizations.netSalesAmount,
        field: "totalAmount",
        type: PlutoColumnType.currency(
          name: '(ILS) ',
          negative: true,
        ),
        width: isDesktop ? width * 0.123 : width * 0.5,
        backgroundColor: columnColors,
        renderer: currencyRenderer,
        footerRenderer: reportResult != null
            ? (rendererContext) {
                return TotalSalesModel.footerRendererPrice(
                    rendererContext, reportResult.totalAmount!);
              }
            : (rendererContext) {
                return footerRenderer(rendererContext, 0);
              },
      ),
    ];

    return list;
  }

  static PlutoAggregateColumnFooter footerRenderer(
      PlutoColumnFooterRendererContext rendererContext, double valueAll) {
    return PlutoAggregateColumnFooter(
      rendererContext: rendererContext,
      formatAsCurrency: false,
      type: PlutoAggregateColumnType.sum,
      alignment: Alignment.center,
      titleSpanBuilder: (text) {
        return [
          TextSpan(
            text: Converters.formatNumber(valueAll),
            style: gridFooterStyleBlue,
          ),
        ];
      },
    );
  }

  static PlutoAggregateColumnFooter footerRendererPrice(
      PlutoColumnFooterRendererContext rendererContext, double valueAll) {
    return PlutoAggregateColumnFooter(
      rendererContext: rendererContext,
      formatAsCurrency: false,
      type: PlutoAggregateColumnType.sum,
      alignment: Alignment.center,
      titleSpanBuilder: (text) {
        return [
          TextSpan(
            text: '(ILS)  ${Converters.formatNumber(valueAll)}  ',
            style: gridFooterStyleBlue,
          ),
        ];
      },
    );
  }

  static Widget currencyRenderer(PlutoColumnRendererContext ctx) {
    assert(ctx.column.type.isCurrency);
    Color color = Colors.black;
    if (ctx.cell.value > 0) {
      color = Colors.black;
    } else if (ctx.cell.value < 0) {
      color = Colors.red;
    }
    return Text(
      ctx.column.type.applyFormat(ctx.cell.value),
      style: TextStyle(color: color, fontSize: 10),
      textAlign: TextAlign.center,
    );
  }
}
