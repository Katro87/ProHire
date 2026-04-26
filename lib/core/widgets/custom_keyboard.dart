import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Keyboard mode enum
enum KeyboardMode {
  numbers,
  letters,
  symbols,
}

/// Custom keyboard widget that works on all platforms
class CustomKeyboard extends StatefulWidget {
  final Function(String) onKeyPressed;
  final VoidCallback? onDelete;
  final VoidCallback? onDone;
  final bool showNumbersOnly;
  final bool initiallyExpanded;
  final FocusNode? focusNode;

  const CustomKeyboard({
    super.key,
    required this.onKeyPressed,
    this.onDelete,
    this.onDone,
    this.showNumbersOnly = false,
    this.initiallyExpanded = true,
    this.focusNode,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> with SingleTickerProviderStateMixin {
  KeyboardMode _mode = KeyboardMode.letters;
  bool _isShiftEnabled = false;
  bool _isCapsLock = false;
  bool _isExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  final List<List<String>> _letterRows = [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'delete'],
  ];

  final List<List<String>> _numberRows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', 'delete'],
  ];

  final List<List<String>> _symbolRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')'],
    ['symbols2', '-', '_', '=', '+', '[', ']', '{', '}', 'delete'],
  ];

  final List<List<String>> _symbolRows2 = [
    ['~', '`', '|', '\\', '<', '>', ',', '.', '?', '/'],
    [':', ';', '\'', '"', '€', '£', '¥', '₹', '±', '§'],
    ['symbols', '©', '®', '™', '•', '°', '¶', '†', '‡', 'delete'],
  ];

  bool _showSymbols2 = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _mode = widget.showNumbersOnly ? KeyboardMode.numbers : KeyboardMode.letters;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleKeyPress(String key) {
    if (key == 'delete') {
      widget.onDelete?.call();
    } else if (key == 'shift') {
      setState(() {
        if (_isCapsLock) {
          _isCapsLock = false;
          _isShiftEnabled = false;
        } else if (_isShiftEnabled) {
          _isCapsLock = true;
        } else {
          _isShiftEnabled = true;
        }
      });
    } else if (key == 'done' || key == 'return') {
      widget.onDone?.call();
    } else if (key == '123' || key == 'abc') {
      setState(() {
        _mode = _mode == KeyboardMode.letters ? KeyboardMode.symbols : KeyboardMode.letters;
        _showSymbols2 = false;
      });
    } else if (key == 'symbols2') {
      setState(() {
        _showSymbols2 = true;
      });
    } else if (key == 'symbols') {
      setState(() {
        _showSymbols2 = false;
      });
    } else if (key == 'space') {
      widget.onKeyPressed(' ');
    } else if (key.isNotEmpty) {
      String charToSend = (_isShiftEnabled || _isCapsLock) ? key.toUpperCase() : key;
      widget.onKeyPressed(charToSend);
      
      // Reset shift after typing (unless caps lock is on)
      if (_isShiftEnabled && !_isCapsLock) {
        setState(() {
          _isShiftEnabled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Toggle bar
        _buildToggleBar(),
        
        // Keyboard content
        SizeTransition(
          sizeFactor: _heightAnimation,
          axisAlignment: -1,
          child: _buildKeyboardContent(),
        ),
      ],
    );
  }

  Widget _buildToggleBar() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: AppTheme.softPurpleBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              size: 24.sp,
              color: AppTheme.grayText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardContent() {
    if (widget.showNumbersOnly || _mode == KeyboardMode.numbers) {
      return _buildNumberPad();
    }
    
    return _buildFullKeyboard();
  }

  Widget _buildNumberPad() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.softPurpleBackground,
      ),
      child: Column(
        children: [
          ..._numberRows.map((row) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildNumberRow(row),
            );
          }),
          SizedBox(height: Responsive.safeBottom),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key.isEmpty) {
          return SizedBox(width: 70.w, height: 50.h);
        }
        
        if (key == 'delete') {
          return _buildNumberKey(
            child: Icon(Icons.backspace_outlined, size: 22.sp, color: AppTheme.darkText),
            onTap: () => _handleKeyPress('delete'),
          );
        }
        
        return _buildNumberKey(
          child: Text(
            key,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.darkText,
            ),
          ),
          onTap: () => _handleKeyPress(key),
        );
      }).toList(),
    );
  }

  Widget _buildNumberKey({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: child,
      ),
    );
  }

  Widget _buildFullKeyboard() {
    final rows = _mode == KeyboardMode.symbols 
        ? (_showSymbols2 ? _symbolRows2 : _symbolRows)
        : _letterRows;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppTheme.softPurpleBackground,
      ),
      child: Column(
        children: [
          ...rows.map((row) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((key) => _buildKey(key)).toList(),
              ),
            );
          }),
          _buildBottomRow(),
          SizedBox(height: Responsive.safeBottom),
        ],
      ),
    );
  }

  Widget _buildKey(String key) {
    final isSpecialKey = key == 'shift' || key == 'delete' || 
                         key == 'symbols' || key == 'symbols2';
    final keyWidth = isSpecialKey ? 44.w : 32.w;
    
    Widget keyContent;
    Color bgColor = AppTheme.white;
    
    if (key == 'shift') {
      final isActive = _isShiftEnabled || _isCapsLock;
      bgColor = isActive ? AppTheme.primaryPurple : AppTheme.white;
      keyContent = Icon(
        _isCapsLock ? Icons.keyboard_capslock : Icons.arrow_upward,
        size: 18.sp,
        color: isActive ? AppTheme.white : AppTheme.darkText,
      );
    } else if (key == 'delete') {
      keyContent = Icon(Icons.backspace_outlined, size: 18.sp, color: AppTheme.darkText);
    } else if (key == 'symbols' || key == 'symbols2') {
      keyContent = Text(
        key == 'symbols2' ? '#+=' : '123',
        style: TextStyle(fontSize: 12.sp, color: AppTheme.darkText, fontWeight: FontWeight.w500),
      );
    } else {
      String displayKey = (_isShiftEnabled || _isCapsLock) ? key.toUpperCase() : key;
      keyContent = Text(
        displayKey,
        style: TextStyle(fontSize: 18.sp, color: AppTheme.darkText),
      );
    }
    
    return GestureDetector(
      onTap: () => _handleKeyPress(key),
      child: Container(
        width: keyWidth,
        height: 42.h,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              offset: const Offset(0, 1),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(child: keyContent),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 123/ABC toggle
          _buildSpecialButton(
            _mode == KeyboardMode.letters ? '123' : 'ABC',
            width: 50.w,
            onTap: () => _handleKeyPress(_mode == KeyboardMode.letters ? '123' : 'abc'),
          ),
          SizedBox(width: 6.w),
          // Space bar
          _buildSpecialButton(
            '',
            width: 160.w,
            isSpace: true,
            onTap: () => _handleKeyPress('space'),
          ),
          SizedBox(width: 6.w),
          // Done/Return button
          _buildSpecialButton(
            'Done',
            width: 70.w,
            isPrimary: true,
            onTap: () => _handleKeyPress('done'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialButton(
    String text, {
    required double width,
    required VoidCallback onTap,
    bool isSpace = false,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 42.h,
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primaryPurple : AppTheme.white,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              offset: const Offset(0, 1),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: isSpace
              ? null
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: isPrimary ? 14.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isPrimary ? AppTheme.white : AppTheme.darkText,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Number-only keyboard widget
class NumberKeyboard extends StatefulWidget {
  final Function(String) onKeyPressed;
  final VoidCallback? onDelete;
  final VoidCallback? onDone;
  final bool initiallyExpanded;

  const NumberKeyboard({
    super.key,
    required this.onKeyPressed,
    this.onDelete,
    this.onDone,
    this.initiallyExpanded = true,
  });

  @override
  State<NumberKeyboard> createState() => _NumberKeyboardState();
}

class _NumberKeyboardState extends State<NumberKeyboard> with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Toggle bar
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: AppTheme.softPurpleBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Center(
              child: Icon(
                _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                size: 24.sp,
                color: AppTheme.grayText,
              ),
            ),
          ),
        ),
        
        // Keyboard content
        SizeTransition(
          sizeFactor: _heightAnimation,
          axisAlignment: -1,
          child: _buildNumberPad(),
        ),
      ],
    );
  }

  Widget _buildNumberPad() {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'delete'],
    ];
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.softPurpleBackground,
      ),
      child: Column(
        children: [
          ...rows.map((row) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildRow(row),
            );
          }),
          SizedBox(height: Responsive.safeBottom),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key.isEmpty) {
          return SizedBox(width: 70.w, height: 50.h);
        }
        
        if (key == 'delete') {
          return _buildKey(
            child: Icon(Icons.backspace_outlined, size: 22.sp, color: AppTheme.darkText),
            onTap: () => widget.onDelete?.call(),
          );
        }
        
        return _buildKey(
          child: Text(
            key,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.darkText,
            ),
          ),
          onTap: () => widget.onKeyPressed(key),
        );
      }).toList(),
    );
  }

  Widget _buildKey({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 50.h,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

/// Input field with hardware keyboard support for desktop/web
class ResponsiveInputField extends StatefulWidget {
  final String value;
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool readOnly;
  final FocusNode? focusNode;

  const ResponsiveInputField({
    super.key,
    required this.value,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
    this.readOnly = false,
    this.focusNode,
  });

  @override
  State<ResponsiveInputField> createState() => _ResponsiveInputFieldState();
}

class _ResponsiveInputFieldState extends State<ResponsiveInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(ResponsiveInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      style: TextStyle(
        fontSize: 16.sp,
        color: AppTheme.darkText,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: AppTheme.lightGray,
        ),
        counterText: '',
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.borderColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.borderColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppTheme.primaryPurple, width: 1.5),
        ),
      ),
      onChanged: widget.onChanged,
      inputFormatters: widget.keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
    );
  }
}
