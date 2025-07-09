# Environment Variables Setup

This project uses environment variables to securely store EmailJS credentials. Follow these steps to set up your environment:

## Development Setup

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env.local
   ```

2. **Edit `.env.local` with your EmailJS credentials:**
   ```bash
   EMAILJS_SERVICE_ID=your_actual_service_id
   EMAILJS_TEMPLATE_ID=your_actual_template_id
   EMAILJS_PUBLIC_KEY=your_actual_public_key
   ```

3. **Run the development server:**
   ```bash
   ./run_dev.sh
   ```

   Or manually:
   ```bash
   flutter run -d chrome \
     --dart-define=EMAILJS_SERVICE_ID="your_service_id" \
     --dart-define=EMAILJS_TEMPLATE_ID="your_template_id" \
     --dart-define=EMAILJS_PUBLIC_KEY="your_public_key"
   ```

## Production Build

1. **Set environment variables in your CI/CD system** or create `.env.production`:
   ```bash
   EMAILJS_SERVICE_ID=your_production_service_id
   EMAILJS_TEMPLATE_ID=your_production_template_id
   EMAILJS_PUBLIC_KEY=your_production_public_key
   ```

2. **Build for production:**
   ```bash
   ./build_prod.sh
   ```

## Getting EmailJS Credentials

1. Sign up at [EmailJS](https://www.emailjs.com/)
2. Create a new service (Gmail, Outlook, etc.)
3. Create an email template
4. Get your:
   - **Service ID**: Found in the EmailJS dashboard under "Services"
   - **Template ID**: Found under "Email Templates"
   - **Public Key**: Found under "Account" → "API Keys"

## Security Notes

- **Never commit** `.env.local` or `.env.production` files to version control
- The `.gitignore` file is configured to exclude these files
- Environment variables are injected at build time using `--dart-define`
- In production, use your CI/CD system's secure environment variable storage

## Troubleshooting

- If email sending fails, check the browser console for error messages
- Verify your EmailJS credentials are correct
- Ensure your EmailJS service and template are properly configured
- Check that environment variables are properly loaded by looking for the debug message in the console
