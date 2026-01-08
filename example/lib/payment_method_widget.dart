part of 'main.dart';

class _MethodWidget extends StatelessWidget {
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final PaymentMethods method;
  final void Function()? onTap;

  const _MethodWidget({required this.isSelected, required this.method, this.onTap, required this.isFirst, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromRGBO(245, 180, 210, 0.5) : null,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? Radius.circular(12) : Radius.circular(0),
            bottom: isLast ? Radius.circular(12) : Radius.circular(0),
          ),
          border: Border.all(color: isSelected ? Colors.black : Colors.transparent),
        ),
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: isSelected ? Colors.black : Colors.grey, width: isSelected ? 6 : 1),
              ),
            ),
            Expanded(child: Text(getLabel(method))),
            Image.asset(getImagePath(method), height: 32, fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }

  String getImagePath(PaymentMethods method) {
    switch (method) {
      case PaymentMethods.kNet:
        return "assets/images/knet.png";
      case PaymentMethods.amex:
        return "assets/images/amex.png";
      case PaymentMethods.creditCard:
        return "assets/images/credit-card.png";
      case PaymentMethods.bede:
        return "assets/images/bede.png";
      case PaymentMethods.applePay:
        return "assets/images/apple-pay.png";
    }
  }

  String getLabel(PaymentMethods method) {
    switch (method) {
      case PaymentMethods.kNet:
        return "K-NET";
      case PaymentMethods.amex:
        return "Amex";
      case PaymentMethods.creditCard:
        return "Credit Card";
      case PaymentMethods.bede:
        return "Bede";
      case PaymentMethods.applePay:
        return "Apple Pay";
    }
  }
}
