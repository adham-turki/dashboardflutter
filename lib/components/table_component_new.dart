import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';

// ignore: must_be_immutable
class TableComponentNew extends StatefulWidget {
  final List<PlutoColumn> plCols;
  final List<PlutoRow> polRows;
  final Widget Function(PlutoGridStateManager stateManager)? footerBuilder;
  final Function(PlutoGridOnSelectedEvent event)? onSelected;
  final Function(PlutoGridOnChangedEvent event)? onChange;

  final Function(PlutoGridOnLoadedEvent event)? onLoaded;
  final Function(PlutoGridOnRowDoubleTapEvent event)? doubleTab;
  final Function(PlutoGridOnRowSecondaryTapEvent event)? rightClickTap;
  final Function(PlutoGridStateManager event)? headerBuilder;
  final Function(PlutoGridOnRowCheckedEvent event)? handleOnRowChecked;
  bool? isWhiteText = false;
  PlutoGridMode? mode;
  Color? borderColor;
  double? rowsHeight;
  double? columnHeight;
  // PlutoGridStateManager stateManger;
  Key? key;
  TableComponentNew(
      {this.key,
      required this.plCols,
      required this.polRows,
      this.onSelected,
      this.columnHeight,
      this.footerBuilder,
      this.isWhiteText,
      this.doubleTab,
      this.rightClickTap,
      this.headerBuilder,
      this.onLoaded,
      this.mode,
      this.onChange,
      this.handleOnRowChecked,
      this.borderColor,
      this.rowsHeight

      // required this.stateManger
      });
  @override
  State<TableComponentNew> createState() => _TableComponentNewState();
}

class _TableComponentNewState extends State<TableComponentNew> {
  double width = 0;
  double height = 0;
  double scrollThickness = 20;
  double scrollRadius = 10;
  late final PlutoGridStateManager stateManager;
  late AppLocalizations locale;

  @override
  void didChangeDependencies() {
    locale = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    List<PlutoColumn> polCols = widget.plCols;
    int maxNumber = 1;
    List<PlutoRow> polRows = widget.polRows;
    for (int i = 0; i < polCols.length; i++) {
      int length = polCols[i].title.split(" ").length;
      if (length > maxNumber) {
        maxNumber = length;
      }
      String title = specialColumnsWidth(polCols, i, locale)
          ? polCols[i].title
          : longSentenceWidth(polCols, i, locale)
              ? '${polCols[i].title.split(' ').take(2).join(' ')}\n${polCols[i].title.split(' ').skip(2).join(' ')}'
              : polCols[i].title.replaceAll(" ", "\n");
      // _locale.lastPricePurchase
      polCols[i].titleSpan = TextSpan(
        children: [
          WidgetSpan(
            child: Text(
              title,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      );
      polCols[i].titleTextAlign = PlutoColumnTextAlign.center;
      polCols[i].textAlign = PlutoColumnTextAlign.center;
    }
    return PlutoGrid(
      configuration: PlutoGridConfiguration(
        enableMoveHorizontalInEditing: true,
        enterKeyAction: PlutoGridEnterKeyAction.editingAndMoveRight,
        columnSize: const PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.none),
        localeText: PlutoGridLocaleText(filterContains: locale.contains),
        scrollbar: PlutoGridScrollbarConfig(
          onlyDraggingThumb: false,
          scrollbarThicknessWhileDragging: 15,
          draggableScrollbar: true,
          isAlwaysShown: true,
          scrollBarColor: primary,
          scrollbarThickness: scrollThickness,
          scrollbarRadius: Radius.circular(scrollRadius),
        ),
        style: PlutoGridStyleConfig(
          evenRowColor: Colors.grey[100],
          oddRowColor: Colors.white,
          activatedBorderColor:
              const Color.fromARGB(255, 37, 171, 233).withOpacity(0.5),
          activatedColor:
              const Color.fromARGB(255, 37, 171, 233).withOpacity(0.5),
          enableCellBorderVertical: false,
          enableGridBorderShadow: true,
          gridBorderColor: widget.borderColor == null
              ? const Color(0xFFA1A5AE)
              : widget.borderColor!,
          menuBackgroundColor: Colors.white,
          columnHeight: widget.columnHeight ?? 30,
          columnFilterHeight: 30,
          columnTextStyle: TextStyle(
              fontSize: 14,
              color: widget.isWhiteText ?? false ? Colors.white : Colors.black,
              letterSpacing: 1),
          rowHeight: widget.rowsHeight ?? 25,
          cellTextStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
      createFooter: (stateManager) {
        if (widget.footerBuilder != null) {
          return widget.footerBuilder!(stateManager);
        }
        return const SizedBox();
      },
      columns: polCols,
      rows: polRows,
      mode: widget.mode != null ? widget.mode! : PlutoGridMode.selectWithOneTap,
      onRowDoubleTap: widget.doubleTab != null
          ? (event) {
              widget.doubleTab!(event);
            }
          : null,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        if (widget.onLoaded != null) {
          widget.onLoaded!(event);
        }
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        if (widget.onChange != null) {
          widget.onChange!(event);
        }
      },
      onSelected: (event) {
        if (widget.onSelected != null) {
          widget.onSelected!(event);
        }
      },
      noRowsWidget: const Center(
        child: Text("No data available."),
      ),
      onRowSecondaryTap: (event) {
        if (widget.rightClickTap != null) {
          widget.rightClickTap!(event);
        }
      },
      createHeader: (stateManager) {
        if (widget.headerBuilder != null) {
          return widget.headerBuilder!(stateManager);
        }
        return const SizedBox();
      },
      onRowChecked: widget.handleOnRowChecked,
    );
  }
}
