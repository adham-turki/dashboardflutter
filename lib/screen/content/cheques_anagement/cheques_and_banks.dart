import 'package:bi_replicate/controller/cheques_management/cheques_payable_controller.dart';
import 'package:bi_replicate/model/cheques_bank/cheques_payable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../components/table_component.dart';
import '../../../controller/inventory_performance/inventory_performance_controller.dart';
import '../../../model/criteria/search_criteria.dart';
import '../../../utils/constants/maps.dart';
import '../../../utils/constants/styles.dart';
import '../../../widget/drop_down/custom_dropdown.dart';

class ChequesAndBankContent extends StatefulWidget {
  const ChequesAndBankContent({super.key});

  @override
  State<ChequesAndBankContent> createState() => _ChequesAndBankContentState();
}

class _ChequesAndBankContentState extends State<ChequesAndBankContent> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  InventoryPerformanceController inventoryPerformanceController =
      InventoryPerformanceController();

  late AppLocalizations _locale;
  List<String> status = [];
  var selectedStatus = "";

  SearchCriteria criteria = SearchCriteria();
  ChequesPayableModel chequesPayableModel =
      ChequesPayableModel(0, 0, 0, 0, 0, 0, 0);

  ChequesPayableController controller = ChequesPayableController();

  List<PlutoRow> polRows = [];

  @override
  void initState() {
    criteria = SearchCriteria(
      voucherStatus: -100,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _locale = AppLocalizations.of(context);

    status = [
      _locale.all,
      _locale.posted,
      _locale.draft,
      _locale.canceled,
    ];

    selectedStatus = status[0];
    super.didChangeDependencies();
  }

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: CustomDropDown(
            label: _locale.status,
            hint: status[0],
            items: status,
            initialValue: selectedStatus.isNotEmpty ? selectedStatus : null,
            height: height * 0.18,
            onChanged: (value) {
              setState(() {
                selectedStatus = value;
                int status = getVoucherStatus(_locale, selectedStatus);
                criteria.voucherStatus = status;
              });
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: height * .03,
            ),
            SizedBox(
              height: height * 0.07,
              child: SelectableText(
                maxLines: 1,
                _locale.chequesPayable,
                style: twenty600TextStyle(Colors.blue[700]),
              ),
            ),
            SizedBox(
              width: width * 0.5,
              height: height * 0.2,
              child: TableComponent(
                key: UniqueKey(),
                plCols: ChequesPayableModel.getColumnsChequesPayable(
                    AppLocalizations.of(context)),
                polRows: [],
                footerBuilder: (stateManager) {
                  return lazyPaginationFooter(stateManager);
                },
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: height * .04,
            ),
            SizedBox(
              height: height * 0.07,
              child: SelectableText(
                maxLines: 1,
                _locale.bankSettlement,
                style: twenty600TextStyle(Colors.blue[700]),
              ),
            ),
            SizedBox(
              width: width * 0.5,
              height: height * 0.2,
              child: TableComponent(
                key: UniqueKey(),
                plCols: ChequesPayableModel.getColumnsBankSettlement(
                    AppLocalizations.of(context)),
                polRows: [],
                footerBuilder: (stateManager) {
                  return lazyPaginationFooter(stateManager);
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * .05,
        ),
      ],
    );
  }

  PlutoLazyPagination lazyPaginationFooter(PlutoGridStateManager stateManager) {
    return PlutoLazyPagination(
      initialPage: 1,
      initialFetch: true,
      pageSizeToMove: null,
      fetchWithSorting: false,
      fetchWithFiltering: false,
      fetch: (request) {
        return fetch(request);
      },
      stateManager: stateManager,
    );
  }

  Future<PlutoLazyPaginationResponse> fetch(
      PlutoLazyPaginationRequest request) async {
    int page = request.page;

    // To send the number of page to the JSON Object
    criteria.page = page;
    List<PlutoRow> topList = [];
    ChequesPayableModel result = await controller.getchequesAndBanks(criteria);
    topList.add(result.toPluto());

    return PlutoLazyPaginationResponse(
      totalPage: 1,
      rows: topList,
    );
  }
}
