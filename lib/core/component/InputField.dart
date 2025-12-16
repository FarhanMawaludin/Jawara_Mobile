import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;

  // Dropdown String
  final List<String>? options;
  final Function(String)? onChanged;

  // Dropdown Key–Value (int value, String label)
  final List<Map<String, dynamic>>? optionsKV;
  final Function(int)? onChangedKV;
  final int? initialValueKV;

  final TextEditingController? controller;

  // Validator untuk String
  final String? Function(String?)? validator;

  // Validator khusus int (KV)
  final String? Function(int?)? validatorKV;

  final bool enabled;
  final bool readOnly;

  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,

    this.options,
    this.onChanged,

    this.optionsKV,
    this.onChangedKV,
    this.initialValueKV,

    this.controller,
    this.validator,
    this.validatorKV,

    this.enabled = true,
    this.readOnly = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;
  String? _selectedValue;
  int? _selectedKey;

  @override
  void initState() {
    super.initState();

    // Initial KV dropdown (int)
    if (widget.optionsKV != null && widget.initialValueKV != null) {
      _selectedKey = widget.initialValueKV;

      final found = widget.optionsKV!.firstWhere(
        (e) => e["value"] == widget.initialValueKV,
        orElse: () => {},
      );
      _selectedValue = found["label"];
    }

    // Initial String dropdown
    if (widget.options != null &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      _selectedValue = widget.controller!.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey[400]!),
    );

    final focusedBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.deepPurpleAccent[400]!),
    );

    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[950],
            ),
          ),
          const SizedBox(height: 6),

          // ===========================================================
          // 1) DROPDOWN KEY-VALUE (INT)
          // ===========================================================
          if (widget.optionsKV != null && widget.optionsKV!.isNotEmpty)
            DropdownButtonFormField<int>(
              value: _selectedKey,

              decoration: InputDecoration(
                hintText: widget.hintText,
                enabledBorder: borderStyle,
                focusedBorder: focusedBorderStyle,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              ),

              validator: widget.validatorKV, // <-- FIXED

              icon: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Icon(Icons.keyboard_arrow_down_rounded,
                    color: widget.enabled
                        ? Colors.grey[500]
                        : Colors.grey[300]),
              ),

              items: widget.optionsKV!.map((item) {
                return DropdownMenuItem<int>(
                  value: item["value"],
                  child: Text(item["label"]),
                );
              }).toList(),

              onChanged: widget.enabled
                  ? (v) {
                      setState(() => _selectedKey = v);
                      if (widget.onChangedKV != null && v != null) {
                        widget.onChangedKV!(v);
                      }
                    }
                  : null,
            )

          // ===========================================================
          // 2) DROPDOWN STRING
          // ===========================================================
          else if (widget.options != null && widget.options!.isNotEmpty)
            DropdownButtonFormField<String>(
              value: widget.options!.contains(_selectedValue)
                  ? _selectedValue
                  : null,

              hint: Text(widget.hintText,
                  style: TextStyle(color: Colors.grey[400])),

              decoration: InputDecoration(
                enabledBorder: borderStyle,
                focusedBorder: focusedBorderStyle,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              ),

              validator: widget.validator,

              icon: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Icon(Icons.keyboard_arrow_down_rounded,
                    color: widget.enabled
                        ? Colors.grey[500]
                        : Colors.grey[300]),
              ),

              items: widget.options!
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ))
                  .toList(),

              onChanged: widget.enabled
                  ? (value) {
                      setState(() => _selectedValue = value);

                      if (widget.controller != null) {
                        widget.controller!.text = value ?? "";
                      }

                      if (widget.onChanged != null && value != null) {
                        widget.onChanged!(value);
                      }
                    }
                  : null,
            )

          // ===========================================================
          // 3) TEXT FIELD
          // ===========================================================
          else
            TextFormField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              validator: widget.validator,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: borderStyle,
                focusedBorder: focusedBorderStyle,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[500],
                        ),
                        onPressed: widget.enabled
                            ? () =>
                                setState(() => _obscureText = !_obscureText)
                            : null,
                      )
                    : null,
              ),
              onChanged: widget.onChanged,
            ),
        ],
      ),
    );
  }
}
