# BMI Calculator Pro — Final Mobile Upload Package

Everything needed for the first build is included here.

## Included
- `lib/main.dart` — complete app
- `app_icon.png` — custom launcher icon
- `pubspec.yaml` — includes launcher icon generator
- `codemagic.yaml` — API 36 + signing + APK + AAB
- `analysis_options.yaml`
- `docs/privacy-policy.html`
- `.gitignore`

## App details
- App name: BMI Calculator Pro
- Package ID: `com.soikot.bmicalculator`
- Target SDK: API 36
- Output: signed APK + signed AAB
- Metric + Imperial
- No login, ads, analytics, or database
- Adult (18+) BMI screening utility

## One-time mobile workflow
1. Create a GitHub repository named `bmicalculatorpro`.
2. Upload the contents of this ZIP to the repository, keeping `lib/main.dart` inside `lib`.
3. Add the repository to Codemagic.
4. Switch to YAML configuration.
5. The workflow uses your existing Codemagic Android signing identity:
   `agecalculator_upload`
6. Start workflow `android-release`.
7. When it finishes, download:
   - `app-release.apk` for your phone
   - `app-release.aab` for Google Play

Because the icon and API 36 configuration are already included, you should not need
another build just to add the icon later.
