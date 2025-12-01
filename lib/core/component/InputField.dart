import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final List<String>? options;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.options,
    this.onChanged,
    this.controller,
    final String? Function(String?)? validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();

    // =============================
    // TAMBAHAN: BACA VALUE AWAL DROPDOWN DARI controller
    // =============================
    if (widget.options != null &&
        widget.options!.isNotEmpty &&
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

          // ==============================================
          //               DROPDOWN
          // ==============================================
          if (widget.options != null && widget.options!.isNotEmpty)
            DropdownButtonFormField<String>(
              // key: widget.key,

              // =============================================
              // TAMBAHAN: Gunakan controller.text sebagai value
              // jika ada.
              // =============================================
              value:
                  widget.options!.contains(
                    _selectedValue ?? widget.controller?.text,
                  )
                  ? (_selectedValue ?? widget.controller?.text)
                  : null,
              hint: Text(
                widget.hintText,
                style: TextStyle(color: Colors.grey[400]),
              ),
              decoration: InputDecoration(
                enabledBorder: borderStyle,
                focusedBorder: focusedBorderStyle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 18,
                ),
              ),

              icon: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[500],
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    widget.hintText,
                    style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.w400),
                  ),
                ),
                ...widget.options!.map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        // <---- STYLE ITEM LIST
                        fontSize: 16,
                        fontWeight: FontWeight.w400, // tidak tebal
                      ),
                    ),
                  ),
                ),
              ],

              onChanged: (value) {
                setState(() => _selectedValue = value);

                // =============================================
                // TAMBAHAN: update controller saat pilih dropdown
                // =============================================
                if (widget.controller != null && value != null) {
                  widget.controller!.text = value;
                }

                if (widget.onChanged != null && value != null) {
                  widget.onChanged!(value);
                }
              },
            )
          // ==============================================
          //               TEXTFIELD
          // ==============================================
          else
            TextField(
              // key: widget.key,
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: borderStyle,
                focusedBorder: focusedBorderStyle,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[500],
                        ),
                        onPressed: () {
                          setState(() => _obscureText = !_obscureText);
                        },
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
