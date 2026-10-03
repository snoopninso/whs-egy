# whs-egy
"مشروع واجهة ويب لـ WHS مبني بـ Flutter"

## Web UI preview

Use the preview entry point to inspect the home screen without the login flow:

```sh
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080 -t lib/web_preview.dart
```

This is for UI preview only. The regular app entry point still starts with the
splash screen and login flow.

## API configuration

Login and registration use JSON `POST` requests. The API base URL is deliberately
empty by default so the app does not send credentials to an unverified address.
Configure the backend and its relative paths at build/run time:

```sh
flutter run \
	--dart-define=API_BASE_URL=https://your-api.example.com/api/ \
	--dart-define=API_LOGIN_PATH=auth/login \
	--dart-define=API_REGISTRATION_PATH=registrations
```

The login request sends `email` and `password`. The registration request sends
`full_name`, `email`, `organization`, `job_title`, `phone`, `attendance_type`,
and `message`. The app treats a 2xx response as success and displays a server
`message` for non-2xx JSON responses. These default paths are provisional and
must match the website backend before enabling the integration.
