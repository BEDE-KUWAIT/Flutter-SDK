# Bede Flutter SDK

A comprehensive Flutter package for integrating Bede payment gateway into your Flutter applications. This SDK provides a simple and secure way to process payments through various payment methods including KNET, AMEX, Credit Cards, Bede, and Apple Pay.

## Features

- **Multiple Payment Methods**: Support for KNET, AMEX, Credit Cards, Bede, and Apple Pay
- **Environment Support**: Test and production environment configurations
- **Payment Status Tracking**: Check payment status in real-time
- **Easy Integration**: Simple API with minimal setup required

## Getting started

### Prerequisites

- Flutter SDK (>=1.17.0)
- Dart SDK (^3.9.0)
- A Bede merchant account with:
  - Merchant ID
  - Secret Key
  - Success URL
  - Failure URL

### Installation

Add `bede_flutter_sdk` to your `pubspec.yaml` file:

```yaml
dependencies:
  bede_flutter_sdk: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### 1. Initialize the SDK

First, initialize the SDK with your merchant credentials:

```dart
import 'package:bede_flutter_sdk/bede_flutter_sdk.dart';

final bedeFlutter = BedeFlutter();

await bedeFlutter.initialize(
  env: Environment.test, // or Environment.production
  merchantID: "your_merchant_id",
  secretKey: "your_secret_key",
  successUrl: "https://yoursite.com/success",
  failureUrl: "https://yoursite.com/failure",
);
```

### 2. Get Available Payment Methods

Fetch the list of available payment methods for your merchant:

```dart
List<PaymentMethods> methods = await bedeFlutter.getPaymentMethods();
// Returns: [PaymentMethods.kNet, PaymentMethods.amex, ...]
```

### 3. Request Payment Link

Request a payment link for a specific payment method:

```dart
String paymentUrl = await bedeFlutter.requestLink(
  paymentMethod: PaymentMethods.kNet,
  amount: 100.50,
  onError: (errorMessage) {
    print('Payment error: $errorMessage');
  },
);

// Launch the payment URL
if (await canLaunchUrl(Uri.parse(paymentUrl))) {
  await launchUrl(Uri.parse(paymentUrl));
}
```

### 4. Check Payment Status

Check the status of a payment transaction:

```dart
PaymentStatus status = await bedeFlutter.checkStatus();

print('Status: ${status.statusDescription}');
print('Final Status: ${status.finalStatus}'); // success, failed, cancelled, initiated
print('Payment ID: ${status.paymentId}');
print('Bank Reference: ${status.bankRefNo}');
```

