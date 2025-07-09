import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// Chart-consistent color scheme matching FilterDialog
const Color primaryColor = Color.fromRGBO(82, 151, 176, 1.0);
const Color primaryLight = Color.fromRGBO(82, 151, 176, 0.05);
const Color primaryMedium = Color.fromRGBO(82, 151, 176, 0.1);
const Color primaryBorder = Color.fromRGBO(82, 151, 176, 0.2);
const Color primaryDark = Color.fromRGBO(62, 131, 156, 1.0);
const Color backgroundColor = Color(0xFFFAFBFC);
const Color cardColor = Colors.white;
const Color textPrimary = Color(0xFF2D3748);
const Color textSecondary = Color(0xFF718096);

// ignore: must_be_immutable
class CustomDropDownSearch extends StatefulWidget {
  double? width;
  double? padding;
  String? bordeText;
  Key? customKey;
  final List<dynamic>? items;
  final ValueChanged<dynamic> onChanged;
  final dynamic initialValue;
  final Function(String)? onValidator;
  final Future<bool?> Function(dynamic)? onBeforeOpening;
  double? heightVal;
  bool? searchBox;
  bool? valSelected;
  dynamic object;
  Color? color;
  String? selectedVal;
  Widget? suffixIcon;
  final Function()? onPressed;
  Icon? icon;
  final Future<List<dynamic>> Function(String)? onSearch;
  final bool? showBorder;
  bool? isEnabled;
  bool? isMandatory;
  
  CustomDropDownSearch({
    Key? key,
    this.width,
    this.initialValue,
    this.valSelected,
    this.onValidator,
    this.items,
    this.padding,
    this.searchBox,
    this.heightVal,
    this.bordeText,
    this.isMandatory = false,
    this.customKey,
    this.isEnabled,
    required this.onChanged,
    this.object,
    this.selectedVal,
    this.suffixIcon,
    this.onPressed,
    this.onSearch,
    this.icon,
    this.onBeforeOpening,
    this.showBorder,
    this.color
  }) : super(key: key);

  @override
  State<CustomDropDownSearch> createState() => _CustomDropDownSearchState();
}

class _CustomDropDownSearchState extends State<CustomDropDownSearch> with TickerProviderStateMixin {
  FocusNode focusNode = FocusNode();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // Responsive breakpoints
  bool get isDesktop => MediaQuery.of(context).size.width >= 1200;
  bool get isTablet => MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1200;
  bool get isMobile => MediaQuery.of(context).size.width < 768;

  // Responsive dimensions
  double get responsiveHeight {
    if (isDesktop) return MediaQuery.of(context).size.height * 0.065;
    if (isTablet) return MediaQuery.of(context).size.height * 0.07;
    return MediaQuery.of(context).size.height * 0.075;
  }

  double get responsiveFontSize {
    if (isDesktop) return 14.0;
    if (isTablet) return 13.0;
    return 12.0;
  }

  double get responsivePadding {
    if (isDesktop) return 16.0;
    if (isTablet) return 14.0;
    return 12.0;
  }

  double get responsiveIconSize {
    if (isDesktop) return 24.0;
    if (isTablet) return 22.0;
    return 20.0;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: _isHovered && (widget.isEnabled ?? true)
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: SizedBox(
            height: responsiveHeight,
            child: DropdownSearch<dynamic>(
              enabled: widget.isEnabled ?? true,
              validator: (value) => widget.onValidator == null ? null : widget.onValidator!(value),
              items: widget.items ?? [],
              asyncItems: widget.onSearch,
              
              // Enhanced dropdown button properties
              dropdownButtonProps: DropdownButtonProps(
                padding: EdgeInsets.all(responsivePadding * 0.3),
                icon: AnimatedRotation(
                  turns: _isHovered ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.icon?.icon ?? Icons.keyboard_arrow_down_rounded,
                    color: (widget.isEnabled ?? true)
                        ? primaryColor
                        : textSecondary,
                    size: responsiveIconSize,
                  ),
                ),
                onPressed: widget.onPressed ?? () {},
              ),
              
              // Enhanced decorator properties
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: _buildInputDecoration(context),
              ),
              
              // Custom dropdown builder
              dropdownBuilder: widget.selectedVal != null || widget.icon != null
                  ? _customDropDownBuilder
                  : null,
              
              // Enhanced popup properties
              popupProps: PopupProps.menu(
                searchDelay: const Duration(milliseconds: 300),
                showSearchBox: widget.searchBox ?? true,
                isFilterOnline: widget.onSearch != null,
                
                // Enhanced search field
                searchFieldProps: TextFieldProps(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: responsiveIconSize * 0.9,
                      color: primaryColor.withOpacity(0.7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: primaryBorder,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: responsivePadding,
                      vertical: responsivePadding * 0.8,
                    ),
                  ),
                ),
                
                // Responsive constraints
                constraints: BoxConstraints(
                  maxHeight: widget.heightVal ?? (screenHeight * 0.4),
                  minHeight: screenHeight * 0.2,
                  maxWidth: screenWidth * 0.9,
                ),
                
                // Enhanced item builder
                itemBuilder: (context, item, isSelected) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: isSelected
                          ? primaryMedium
                          : Colors.transparent,
                    ),
                    child: ListTile(
                      dense: isMobile,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: responsivePadding,
                        vertical: responsivePadding * 0.3,
                      ),
                      leading: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: primaryColor,
                              size: responsiveIconSize * 0.8,
                            )
                          : null,
                      title: Text(
                        item.toString(),
                        style: TextStyle(
                          fontSize: responsiveFontSize,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? primaryColor
                              : textPrimary,
                        ),
                      ),
                    ),
                  );
                },
                
                // Enhanced menu properties
                menuProps: MenuProps(
                  backgroundColor: cardColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              
              onBeforePopupOpening: widget.onBeforeOpening,
              onChanged: (value) {
                widget.onChanged(value);
              },
              selectedItem: widget.initialValue,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    if (widget.showBorder == false) {
      return InputDecoration(
        contentPadding: EdgeInsets.all(responsivePadding),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
      );
    }

    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsivePadding,
        vertical: responsivePadding * 0.8,
      ),
      
      // Enhanced border styling
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: primaryBorder,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: primaryBorder,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: textSecondary,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      
      // Enhanced label
      label: _buildLabel(context),
      labelStyle: TextStyle(
        fontSize: responsiveFontSize,
        color: textSecondary,
        fontWeight: FontWeight.w500,
      ),
      
      floatingLabelStyle: TextStyle(
        fontSize: responsiveFontSize * 0.9,
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      
      // Fill styling
      filled: true,
      fillColor: (widget.isEnabled ?? true)
          ? cardColor
          : textSecondary.withOpacity(0.1),
    );
  }

  Widget _buildLabel(BuildContext context) {
    if (widget.bordeText == null) return const SizedBox.shrink();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.bordeText!,
          style: TextStyle(fontSize: responsiveFontSize),
        ),
        if (widget.isMandatory ?? false) ...[
          const SizedBox(width: 4),
          Text(
            "*",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: responsiveFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _customDropDownBuilder(BuildContext context, dynamic item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = widget.width ?? screenWidth * (isDesktop ? 0.15 : isMobile ? 0.8 : 0.3);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: responsivePadding * 0.5),
      child: Row(
        children: [
          Expanded(
            child: _buildDisplayText(context, item, maxWidth),
          ),
          if (widget.icon != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: (widget.isEnabled ?? true)
                  ? primaryColor.withOpacity(0.7)
                  : textSecondary,
              size: responsiveIconSize,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDisplayText(BuildContext context, dynamic item, double maxWidth) {
    String displayText = '';
    Color textColor = textPrimary;
    FontWeight fontWeight = FontWeight.w400;

    if (widget.selectedVal != null) {
      displayText = widget.selectedVal!;
      fontWeight = FontWeight.w500;
    } else if (item != null) {
      displayText = item.toString();
      fontWeight = FontWeight.w500;
    } else {
      displayText = widget.bordeText ?? '';
      textColor = textSecondary;
    }

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth * 0.8),
      child: Text(
        displayText,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: responsiveFontSize,
          color: textColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}