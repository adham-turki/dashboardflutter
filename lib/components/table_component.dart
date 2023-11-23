import 'package:bi_replicate/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableComponent extends StatefulWidget {
  final List<PlutoColumn> plCols;
  final List<PlutoRow> polRows;
  final Widget Function(PlutoGridStateManager stateManager)? footerBuilder;
  final Function(PlutoGridOnSelectedEvent event)? onSelected;
  final Function(PlutoGridOnRowDoubleTapEvent event)? doubleTab;
  final Function(PlutoGridOnRowSecondaryTapEvent event)? rightClickTap;
  final Function(PlutoGridStateManager event)? headerBuilder;
  final Function(PlutoGridStateManager event)? onLoaded;
  final Key key;
  PlutoGridStateManager? stateManager;
  TableComponent(
      {required this.key,
      // super.key,
      required this.plCols,
      required this.polRows,
      this.onSelected,
      this.footerBuilder,
      this.doubleTab,
      this.rightClickTap,
      this.headerBuilder,
      this.onLoaded,
      this.stateManager});
  @override
  State<TableComponent> createState() => _TableComponentState();
}

class _TableComponentState extends State<TableComponent> {
  double width = 0;
  double height = 0;
  double scrollThickness = 20;
  double scrollRadius = 10;
  late final PlutoGridStateManager stateManager;
  // var _preventContextMenu;
  @override
  void initState() {
    // _preventContextMenu = (html.Event event) => {
    //       event.preventDefault(),
    //     };
    // html.document.addEventListener('contextmenu', _preventContextMenu);
    super.initState();
  }

  @override
  void dispose() {
    //  html.document.removeEventListener('contextmenu', _preventContextMenu);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    List<PlutoColumn> polCols = widget.plCols;
    List<PlutoRow> polRows = widget.polRows;
    print("fetch(): ${polRows.length}");
    return PlutoGrid(
      configuration: PlutoGridConfiguration(
        scrollbar: PlutoGridScrollbarConfig(
          scrollbarThickness: scrollThickness,
          scrollbarRadius: Radius.circular(scrollRadius),
        ),
        style: PlutoGridStyleConfig(
          enableRowColorAnimation: true,
          activatedColor: gridActiveColor,
          menuBackgroundColor: Colors.white,
          // iconColor: Colors.white,
          columnHeight: 50,
          columnTextStyle: const TextStyle(
              fontSize: 14, color: Colors.white, letterSpacing: 1),
          oddRowColor: Colors.grey[100],
          evenRowColor: Colors.white,
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
      mode: PlutoGridMode.selectWithOneTap,
      onRowDoubleTap: (event) {
        if (widget.doubleTab != null) {
          widget.doubleTab!(event);
        }
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        widget.stateManager = event.stateManager;
        widget.onLoaded!(event.stateManager);
        stateManager = event.stateManager;
        stateManager.setShowColumnFilter(false);
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        // print(event);
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
    );
  }
}
