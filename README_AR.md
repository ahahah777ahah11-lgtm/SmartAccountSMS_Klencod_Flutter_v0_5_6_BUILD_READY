# رسائل المحاسب الذكي — مشروع Flutter لـ Klencod IDE

هذه حزمة Flutter فعلية، وليست ملف Kodular AIA. استُخدم فيها `pubspec.yaml` قياسي لتفادي فشل خطوة `Get dependencies` بسبب غياب ملف Flutter أو تعريف الحزم.

## طريقة الاستخدام
1. فك ضغط `SmartAccountSMS_Klencod_Flutter.zip` في مستودع GitHub جديد أو ارفع محتويات المجلد إلى مستودعك.
2. في Klencod IDE اختر مستودع المشروع/مسار الجذر الذي يحتوي `pubspec.yaml`.
3. شغّل `flutter pub get` ثم Build APK.
4. إذا كان Klencod يبني من GitHub Actions، تأكد أن مسار المشروع هو جذر المستودع وليس مجلدًا فرعيًا آخر.

## الحزم
- Flutter SDK
- `webview_flutter`
- `url_launcher`

## ملاحظات مهمة
- الواجهة الحالية هي ملف HTML المرفق من الإصدار 0.5 داخل WebView.
- روابط SMS وWhatsApp الخارجية تُمرر إلى التطبيقات المثبتة على الهاتف؛ لا يعني ذلك إرسالًا صامتًا تلقائيًا.
- دعم اختيار ملف `.db` من داخل WebView قد يختلف حسب تنفيذ Android WebView في بيئة البناء. إذا لم يفتح منتقي الملفات، يلزم إضافة منتقي ملفات أصلي في Flutter ثم تمرير الملف إلى الواجهة.
- لم يتم إنتاج APK داخل هذه البيئة؛ يجب تشغيل البناء في Klencod IDE أو Flutter SDK.

## إصلاح خطأ Build APK (android/app/build.gradle غير موجود)
أضيف مجلد `android/` كاملًا إلى هذه النسخة، ويحتوي على `android/app/build.gradle` وملفات إعداد Gradle و`MainActivity.kt`. ارفع **كل محتويات الحزمة إلى جذر مستودع GitHub** بحيث يكون المسار `android/app/build.gradle` موجودًا بجانب `pubspec.yaml` و`lib/`. لا ترفع مجلدًا إضافيًا متداخلًا داخل المستودع.

ملاحظة: `android/gradlew` في هذه الحزمة يقوم بتنزيل Gradle 8.14.3 عند أول بناء، لذا يحتاج اتصالًا بالإنترنت في بيئة البناء.

## الإصدار 0.5.3 — إصلاح Gradle
- تم تحديث Gradle Wrapper من 8.13 إلى 8.14.3 لأن Flutter 3.47.2 يتطلب Gradle 8.14.0 أو أحدث.
- لم يتم تغيير ملفات الواجهة أو منطق التطبيق في هذا الإصلاح.
- بعد رفع الملفات إلى GitHub، أعد تشغيل Build APK.


## الإصدار 0.5.5 — إصلاح خطأ Dart

تم استبدال `const SystemEncoding()` غير الصالح في `lib/main.dart` باستخدام `utf8` مع استيراد `dart:convert`، وتحديث رقم الإصدار. يتطلب تأكيد نجاح APK بتشغيل البناء في بيئة Klencod IDE.

## بناء APK عبر GitHub Actions

أضيف سير عمل تلقائي في `.github/workflows/build-apk.yml`. ارفع المشروع إلى مستودع GitHub ثم افتح تبويب **Actions** وشغّل **Build Android APK**. يفحص سير العمل كود Dart ثم يبني نسخة Release ويرفع `app-release.apk` كملف Artifact. نجاح البناء الفعلي لا يمكن تأكيده قبل تشغيل هذا السير العمل في بيئة Flutter/Android كاملة.
