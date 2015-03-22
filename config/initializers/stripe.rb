Rails.configuration.stripe = {
  publishable_key: "pk_test_Wah9lA5G9KC0JfKICOBK0b7j",
  secret_key:      "sk_test_klYc0uPTKRpd0fvXFlQEUf9O"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]