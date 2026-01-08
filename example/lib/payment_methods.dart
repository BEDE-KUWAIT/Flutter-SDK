part of 'main.dart';

class _PaymentMethods extends StatelessWidget {
  final List<PaymentMethods> paymentMethods;
  final PaymentMethods? selectedMethod;
  final void Function(PaymentMethods method) onTap;

  const _PaymentMethods({required this.paymentMethods, required this.selectedMethod, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Payment Method", style: TextStyle(fontSize: 18)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: paymentMethods.length,
            itemBuilder: (BuildContext context, int index) {
              return _MethodWidget(
                isFirst: index == 0,
                isLast: index == (paymentMethods.length - 1),
                isSelected: selectedMethod == paymentMethods[index],
                method: paymentMethods[index],
                onTap: () {
                  onTap(paymentMethods[index]);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.grey.shade300, height: 1);
            },
          ),
        ),
      ],
    );
  }
}
