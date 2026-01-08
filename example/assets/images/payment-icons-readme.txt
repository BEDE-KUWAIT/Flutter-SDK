Payment Method Icons Required
=============================

Please add the following image files to this directory:

1. knet.png - KNET payment method logo
2. credit-card.png - Credit card (Visa/Mastercard) logo
3. bookeey-wallet.png - Bede wallet logo
4. amex.png - American Express logo
5. bede.png - Main Bede logo (already required for gateway)

Recommended specifications:
- Format: PNG with transparent background
- Dimensions: 200x80 pixels (or similar aspect ratio)
- File size: Under 50KB each
- Style: Clean, modern logos that match your brand

Alternative: You can also use SVG files by updating the image paths in:
- templates/payment-selection.php
- includes/class-wc-bookeey-gateway.php (display_payment_methods function)

If you don't have these images yet, you can use placeholder images or icons from:
- Font Awesome icons
- Payment method icons from: https://github.com/aaronfagan/svg-credit-card-payment-icons
- Your payment processor's brand resources 