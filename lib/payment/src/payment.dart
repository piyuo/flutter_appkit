import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'payment_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment extends StatelessWidget {
  const Payment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentProvider(),
      child: const Text('hello'),
    );
  }
}

Future<void> checkout() async {
  //Stripe.nopublishableKey =
  //  'pk_test_no51K0JreEK9sUapl1UayifecqRLAqcaQGnOusZtsKYZ9q1gZKdHQtJYjNkxPZ83K4h2pLJqz5L0cUyhfRyOhHvWEgg00BCpfv5Pr';
/*
  /// retrieve data from the backend
  final paymentSheetData = backend.fetchPaymentSheetData();

  await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
    applePay: true,
    googlePay: true,
    style: ThemeMode.dark,
    testEnv: true,
    merchantCountryCode: 'US',
    merchantDisplayName: 'Flutter Stripe Store Demo',
    customerId: _paymentSheetData!['customer'],
    paymentIntentClientSecret: _paymentSheetData!['paymentIntent'],
    customerEphemeralKeySecret: _paymentSheetData!['ephemeralKey'],
  ));
*/
  await Stripe.instance.presentPaymentSheet();
}
