part of 'main.dart';

class _InputField extends StatelessWidget {
  final void Function(String)? onChanged;

  const _InputField({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Amount", style: TextStyle(fontSize: 18)),
        TextFormField(
          decoration: InputDecoration(
            hintText: "0.000",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color.fromRGBO(64, 64, 64, 1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
          ],
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Amount cannot be empty';
            }
            final num amount = num.parse(value);
            if (amount == 0) {
              return 'Amount cannot be zero';
            }
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}
