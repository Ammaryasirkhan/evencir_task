# EvenCir Flutter Interview Task

A polished Flutter wellness app with four main modules:

- Nutrition
- Plan
- Mood
- Profile

## 1. Dependencies Used & Why

- `flutter`: Core SDK for building the app.
- `go_router`: Used for structured navigation with `StatefulShellRoute.indexedStack` and bottom-tab routing.
- `flutter_screenutil`: Used for responsive sizing/scaling across different screen sizes.
- `cupertino_icons`: Provides Cupertino-style icon support where needed.

## 2. Project Structure

```text
lib/
 ├── common/
 │   ├── app_assets.dart          # Central asset path constants
 │   ├── app_responsive.dart      # MediaQuery/responsive helpers
 │   ├── app_routes.dart          # App routing + bottom navigation shell
 │   └── widgets/
 │       └── app_text.dart        # Reusable text widget
 │
 ├── features/
 │   ├── nutrition/presentation/  # Nutrition UI + calendar bottom sheet + dynamic insights
 │   ├── plan/presentation/       # Training calendar/plan UI
 │   ├── mood/presentation/       # Mood wheel with interactive ring and mood image mapping
 │   └── profile/presentation/    # Profile UI (avatar, name/email, logout)
 │
 └── main.dart                    # App bootstrap + ScreenUtil initialization
```

## 3. App Screenshots

- [All Screenshots Folder](./screenshots)
- [Screenshot 1](./screenshots/simulator_screenshot_27A97653-6214-4B99-B961-E86DE37BD98C.png)
- [Screenshot 2](./screenshots/simulator_screenshot_45B54C66-5B45-4D66-81C6-6D20695345C6.png)
- [Screenshot 3](./screenshots/simulator_screenshot_73BDB953-0A2B-4B0B-8C99-22845A3717FA.png)
- [Screenshot 4](./screenshots/simulator_screenshot_74A28119-E56C-460F-AA2D-595D51C4EF04.png)
- [Screenshot 5](./screenshots/simulator_screenshot_77ED3DB6-04E8-43D7-9F3F-CDA5082994C2.png)
- [Screenshot 6](./screenshots/simulator_screenshot_8D032021-3911-4F58-9A16-1548B42DB379.png)
- [Screenshot 7](./screenshots/simulator_screenshot_E0CCC1DA-14AC-4353-AA3D-FE5DAF887179.png)
- [Screenshot 8](./screenshots/simulator_screenshot_ED8239EC-A274-44CE-8822-3311A9E3EB40.png)

## 4. App Video

- [Watch App Demo Video](./demo/Screen%20Recording%202026-05-12%20at%208.55.07%E2%80%AFPM.mov)

## 5. App APK

- Release APK will be attached in GitHub Releases.
- Replace the link below after uploading APK to a release:

[Download APK](https://github.com/Ammaryasirkhan/evencir_task/releases/download/Test/app-release.apk)

---

## How To Run

```bash
flutter pub get
flutter run
```
