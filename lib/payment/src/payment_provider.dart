import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentProvider with ChangeNotifier {
  PaymentProvider() {
    Stripe.publishableKey =
        'pk_test_51K0JreEK9sUapl1UayifecqRLAqcaQGnOusZtsKYZ9q1gZKdHQtJYjNkxPZ83K4h2pLJqz5L0cUyhfRyOhHvWEgg00BCpfv5Pr';
  }
}
