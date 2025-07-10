# Security Configuration Guide

## Environment Variables

This example app uses the `flutter_dotenv` package to securely manage sensitive configuration data from `.env` files.

### Required Environment Variables

- `SENTRY_DSN`: Your Sentry project DSN for error reporting

### Setup Instructions

1. Copy the example environment file:

   ```bash
   cp .env.example .env
   ```

2. Get your Sentry DSN:
   - Sign up at [Sentry.io](https://sentry.io) (free tier available)
   - Create a new Flutter project
   - Copy the DSN from your project settings
   - It looks like: `https://your-key@sentry.io/your-project-id`

3. Add your DSN to the `.env` file:

   ```bash
   SENTRY_DSN=https://your-actual-sentry-dsn@sentry.io/your-project-id
   ```

4. Run the app (environment variables are automatically loaded):

   ```bash
   flutter run
   ```

### How it Works

The app uses the `flutter_dotenv` package which:

- Loads environment variables from the `.env` file at startup
- Makes variables accessible via `dotenv.env['VARIABLE_NAME']`
- Works across all platforms (mobile, web, desktop)
- No command-line arguments needed

### Security Best Practices

- ✅ **DO**: Use environment variables for sensitive data
- ✅ **DO**: Keep `.env` in `.gitignore`
- ✅ **DO**: Use `.env.example` to document required variables
- ✅ **DO**: Use `flutter_dotenv` package for reliable .env file loading
- ❌ **DON'T**: Hardcode API keys, tokens, or DSNs in source code
- ❌ **DON'T**: Commit `.env` files to version control
- ❌ **DON'T**: Share sensitive values in code reviews or chat

### Development vs Production

For production deployment, set environment variables through your hosting platform's configuration system (e.g., Firebase Environment Config, Heroku Config Vars, etc.) rather than using `.env` files.
