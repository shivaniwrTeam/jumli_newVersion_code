# eClassify

### 🧰 System Requirements

- **Flutter SDK**: Stable channel, version `3.29.2`
- **Java**: Version `22`

---

### 📄 Installation & User Guide

Thank you for choosing our app!  
To learn how to install and use the app, please visit the full documentation:

👉 **[View Documentation](https://wrteamdev.github.io/eClassify/)**

---

### 💬 Need Help?

If you have any questions or need support, feel free to reach out to our team:

👉 **[Contact Support on Microsoft Teams](https://teams.live.com/l/invite/FEAKcu4QI48saEDvQg)**

---

### 🚀 Run the Application

```shell
flutter run
```


📦 Update iOS Pods
```shell
cd ios
pod init
pod update
pod install
cd ..
```

🧹 Clean Pub Cache
```shell
flutter clean
flutter pub cache clean
flutter pub get
```

🔧 Repair Pub Cache
```shell
flutter clean
flutter pub cache repair
flutter pub get
```



📱 Generate Android APK
```shell
flutter build apk --split-per-abi
open  build/app/outputs/flutter-apk/
```

🛠️ Solve Common iOS Errors
```shell
flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf Flutter/Flutter.podspec
rm ios/podfile.lock
cd ios 
pod deintegrate
sudo rm -rf ~/Library/Developer/Xcode/DerivedData
flutter pub cache repair
flutter pub get 
pod install 
pod update 
```
# jumli_newVersion_code
