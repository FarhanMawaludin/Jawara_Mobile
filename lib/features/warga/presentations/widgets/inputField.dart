// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final List<String>? options;
  final Function(String)? onChanged;

  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.options,
    this.onChanged,
  });


  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;
  String? _selectedValue;

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

          if (widget.options != null && widget.options!.isNotEmpty)
            DropdownButtonFormField<String>(
              initialValue: _selectedValue,
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
              items: widget.options!
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedValue = value);
                if (widget.onChanged != null && value != null) {
                  widget.onChanged!(value);
                }
              },
            )
          else
            TextField(
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
