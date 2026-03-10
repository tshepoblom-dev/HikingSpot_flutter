# Firebase Setup Guide — HikingSpot

Follow these steps exactly. The code is already written; you only need to supply
the Firebase project credentials and make two small platform config changes.

---

## 1. Create a Firebase Project

1. Go to https://console.firebase.google.com
2. Click **Add project** → name it `hikingspot` (or any name)
3. Enable **Google Analytics** when prompted
4. Wait for the project to be created

---

## 2. Add Your Apps to the Project

### Android
1. Click **Android** icon on the project overview
2. **Package name:** `com.yourcompany.hikingspot`  
   *(must match `applicationId` in `android/app/build.gradle`)*
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

### iOS
1. Click **iOS** icon
2. **Bundle ID:** `com.yourcompany.hikingspot`  
   *(must match your Xcode project Bundle Identifier)*
3. Download `GoogleService-Info.plist`
4. Open Xcode → drag the file into `Runner/` (check "Copy items if needed")

---

## 3. Generate `firebase_options.dart` (Recommended)

The easiest way — replaces the placeholder file automatically:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

This overwrites `lib/core/firebase/firebase_options.dart` with real values.

**OR** manually fill in the placeholder values in  
`lib/core/firebase/firebase_options.dart` from the Firebase console
(**Project settings → Your apps → SDK setup and configuration**).

---

## 4. Platform Config

### Android — `android/build.gradle` (project-level)
```groovy
dependencies {
    classpath 'com.google.gms:google-services:4.4.2'
    classpath 'com.google.firebase:firebase-crashlytics-gradle:3.0.2'
}
```

### Android — `android/app/build.gradle` (app-level)
```groovy
// At the TOP of the file, after `apply plugin: 'com.android.application'`
apply plugin: 'com.google.gms.google-services'
apply plugin: 'com.google.firebase.crashlytics'

// Inside android { defaultConfig { ... } }
minSdkVersion 21   // Required by Firebase
```

### Android — `android/app/src/main/AndroidManifest.xml`

Add inside `<application>`:
```xml
<!-- FCM default notification channel -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="hikingspot_high" />

<!-- FCM default notification icon -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@mipmap/ic_launcher" />
```

### iOS — `ios/Runner/AppDelegate.swift`

Ensure it looks like this:
```swift
import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### iOS — Xcode capabilities
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner → Signing & Capabilities**
3. Click **+ Capability** and add:
   - **Push Notifications**
   - **Background Modes** → check **Remote notifications**

---

## 5. Enable Firebase Services in Console

### Firebase Cloud Messaging (FCM)
Already enabled by default. No extra steps needed.

### Firebase Crashlytics
1. Go to **Crashlytics** in the sidebar
2. Click **Enable Crashlytics**
3. Run the app once — Crashlytics needs a first run to activate

### Firebase Analytics
Already enabled if you chose Google Analytics during project creation.

---

## 6. Server-Side: Handle FCM Token Endpoints

Your ASP.NET Core backend needs two new endpoints (add to your notifications controller):

```csharp
// POST /api/notifications/register-token
[HttpPost("register-token")]
[Authorize]
public async Task<IActionResult> RegisterFcmToken([FromBody] FcmTokenDto dto)
{
    // Save dto.Token + platform to a UserDevice table
    // associated with the current user
    await _notifications.RegisterDeviceTokenAsync(dto.Token, dto.Platform, UserId());
    return Ok();
}

// DELETE /api/notifications/register-token  
[HttpDelete("register-token")]
[Authorize]
public async Task<IActionResult> UnregisterFcmToken([FromBody] FcmTokenDto dto)
{
    await _notifications.UnregisterDeviceTokenAsync(dto.Token, UserId());
    return Ok();
}
```

### Sending a push notification from your server

When you call `INotificationService.SendNotificationAsync()`, also send via FCM:

```csharp
// Add to your notification service
using FirebaseAdmin;
using FirebaseAdmin.Messaging;

var message = new Message
{
    Token = userFcmToken,   // retrieved from your UserDevice table
    Notification = new Notification
    {
        Title = title,
        Body  = body,
    },
    Data = new Dictionary<string, string>
    {
        // These drive deep-linking in the app:
        // type: booking | booking_manage | chat | ride_request | ride_offer | trip | general
        { "type", "booking" },
        { "id",   bookingId.ToString() },
    },
    Android = new AndroidConfig
    {
        Priority = Priority.High,
        Notification = new AndroidNotification
        {
            ChannelId = "hikingspot_high",
        },
    },
};
await FirebaseMessaging.DefaultInstance.SendAsync(message);
```

Install the Firebase Admin SDK on your server:
```bash
dotnet add package FirebaseAdmin
```

Initialise it once in `Program.cs`:
```csharp
FirebaseApp.Create(new AppOptions
{
    Credential = GoogleCredential.FromFile("path/to/serviceAccountKey.json")
});
```

Download the service account key from:  
**Firebase Console → Project Settings → Service accounts → Generate new private key**

---

## 7. Install Dependencies & Run

```bash
flutter pub get

# Delete stale generated files first
Get-ChildItem -Path .\lib -Recurse -Include "*.freezed.dart","*.g.dart" | Remove-Item -Force

# Regenerate
dart run build_runner build --delete-conflicting-outputs

flutter run
```

---

## Notification Data Payload Reference

The `data` map you send from the server controls where the app navigates on tap:

| `type`           | `id`         | Navigates to                    |
|------------------|--------------|---------------------------------|
| `booking`        | —            | My Bookings screen              |
| `booking_manage` | —            | Manage Bookings (driver)        |
| `chat`           | bookingId    | Chat screen for that booking    |
| `ride_request`   | —            | My Ride Requests screen         |
| `ride_offer`     | —            | My Ride Requests screen         |
| `trip`           | tripId       | Trip Details screen             |
| `general`        | —            | Notifications screen            |

---

## What Was Implemented

| File | Change |
|------|--------|
| `lib/core/firebase/firebase_options.dart` | Placeholder — fill with FlutterFire CLI |
| `lib/core/firebase/firebase_service.dart` | FCM init, local notifications, Crashlytics, Analytics |
| `lib/main.dart` | Firebase.initializeApp, background handler, Crashlytics zone |
| `lib/core/router/app_router.dart` | Notification tap listener → deep-link navigation; unread badge |
| `lib/features/auth/presentation/providers/auth_provider.dart` | FCM token register/unregister on login/logout; Analytics + Crashlytics user identity |
| `lib/features/notifications/data/datasources/notifications_api_service.dart` | `registerFcmToken()` and `unregisterFcmToken()` |
| `lib/features/notifications/presentation/screens/notifications_screen.dart` | Badge invalidation on open/read/mark-all |
