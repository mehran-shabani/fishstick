# Blood Sugar Tracker - ثبت قند خون 🩸

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-Automated-success.svg)](.github/workflows/)

یک اپلیکیشن Flutter حرفه‌ای برای ثبت و پیگیری قند خون با تقویم شمسی و سیستم CI/CD کامل

## ✨ ویژگی‌های اپلیکیشن

### 📱 ویژگی‌های اصلی
- 📅 **تقویم شمسی**: ثبت اطلاعات با تاریخ شمسی (جلالی)
- 📊 **نمودارهای جداگانه**: نمایش نمودار قند خون ناشتا و غیر ناشتا در 3 ماه گذشته
- 💾 **ذخیره محلی**: ذخیره‌سازی داده‌ها به صورت محلی با SQLite
- 🔄 **یک ثبت در روز**: امکان ثبت یا ویرایش تنها یک مورد در هر روز
- 📈 **آمار پیشرفته**: نمایش میانگین، بیشترین و کمترین مقادیر
- 🎨 **رابط کاربری زیبا**: طراحی مدرن و کاربرپسند با Material Design 3

### 🤖 CI/CD Automation
- ✅ **Build خودکار**: ساخت خودکار APK و AAB در هر کامیت
- ✅ **نسخه‌گذاری هوشمند**: افزایش خودکار نسخه (+0.01 در هر کامیت)
- ✅ **تگ‌گذاری خودکار**: ایجاد خودکار تگ Git برای هر نسخه
- ✅ **Release خودکار**: انتشار خودکار در GitHub با فایل‌های قابل دانلود
- ✅ **تست خودکار**: اجرای تست‌ها و بررسی کد در هر PR
- ✅ **Manual Release**: امکان انتشار دستی با کنترل کامل

## 🚀 شروع سریع

### برای کاربران (دانلود و نصب)

1. به صفحه [Releases](../../releases) بروید
2. آخرین نسخه را دانلود کنید (`app-release.apk`)
3. فایل APK را روی گوشی اندروید خود نصب کنید
4. از اپلیکیشن لذت ببرید! 🎉

### برای توسعه‌دهندگان (Development)

#### پیش‌نیازها
- Flutter SDK 3.0.0+
- Git
- Android Studio / VS Code (اختیاری)

#### نصب و اجرا

```bash
# 1. کلون پروژه
git clone <repository-url>
cd blood_sugar_tracker

# 2. نصب dependencies
flutter pub get

# 3. اجرای اپلیکیشن
flutter run

# 4. یا ساخت APK
flutter build apk --release
```

#### راه‌اندازی CI/CD

برای فعال‌سازی CI/CD خودکار:

```bash
# 1. Push به GitHub
git push origin main

# 2. تنظیم GitHub Actions
# Settings → Actions → General
# - Workflow permissions: "Read and write"
# - ✅ Allow GitHub Actions to create and approve pull requests

# 3. تمام! 🎉
# از این به بعد هر کامیت = Release خودکار
```

📚 **راهنمای کامل**: [SETUP.md](SETUP.md)

## استفاده

### ثبت قند خون

1. در صفحه **ثبت**، مقدار قند خون خود را وارد کنید
2. وضعیت ناشتایی (ناشتا یا غیر ناشتا) را انتخاب کنید
3. روی دکمه **ثبت قند خون** کلیک کنید
4. اگر قبلاً برای امروز ثبت کرده‌اید، اطلاعات قبلی جایگزین می‌شود

### مشاهده نمودارها

1. روی تب **نمودار** کلیک کنید
2. دو نمودار جداگانه برای قند خون ناشتا و غیر ناشتا نمایش داده می‌شود
3. آمار میانگین، بیشترین و کمترین مقادیر برای هر نمودار نمایش داده می‌شود
4. برای بروزرسانی داده‌ها، صفحه را به پایین بکشید (Pull to Refresh)

## وابستگی‌ها

- `shamsi_date`: برای کار با تقویم شمسی
- `fl_chart`: برای نمایش نمودارها
- `sqflite`: برای ذخیره‌سازی محلی داده‌ها
- `path`: برای مدیریت مسیرها

## ساختار پروژه

```
lib/
├── main.dart                 # نقطه شروع برنامه
├── models/
│   └── blood_sugar_entry.dart    # مدل داده قند خون
├── database/
│   └── database_helper.dart      # مدیریت پایگاه داده
└── screens/
    ├── home_screen.dart          # صفحه اصلی با نوار پایین
    ├── entry_screen.dart         # صفحه ثبت قند خون
    └── charts_screen.dart        # صفحه نمودارها
```

## مقادیر مرجع قند خون

- **قند خون طبیعی ناشتا**: 70-100 mg/dL
- **قند خون طبیعی غیر ناشتا**: کمتر از 140 mg/dL
- **پیش دیابت ناشتا**: 100-125 mg/dL
- **دیابت**: بیش از 126 mg/dL (ناشتا)

## توجه

این برنامه صرفاً برای پیگیری شخصی طراحی شده و جایگزین مشاوره پزشکی نیست. همیشه با پزشک خود مشورت کنید.

## 📚 مستندات

- **[SETUP.md](SETUP.md)** - راهنمای راه‌اندازی سریع در 5 دقیقه
- **[RELEASE.md](RELEASE.md)** - راهنمای کامل Release و نسخه‌گذاری
- **[.github/WORKFLOW_GUIDE.md](.github/WORKFLOW_GUIDE.md)** - راهنمای جامع CI/CD Workflows
- **[.github/ARCHITECTURE.md](.github/ARCHITECTURE.md)** - معماری پروژه و سیستم‌ها

## 🔧 اسکریپت‌های کمکی

```bash
# مدیریت نسخه (تعاملی)
./scripts/version.sh

# ساخت Release (APK + AAB)
./scripts/build-release.sh
```

## 🤝 مشارکت

1. Fork کنید
2. Feature branch بسازید (`git checkout -b feature/amazing-feature`)
3. تغییرات را کامیت کنید (`git commit -m 'feat: add amazing feature'`)
4. Push کنید (`git push origin feature/amazing-feature`)
5. Pull Request باز کنید

CI/CD به صورت خودکار کد شما را بررسی می‌کند! ✨

## 🐛 گزارش باگ و درخواست ویژگی

از [GitHub Issues](../../issues) استفاده کنید:
- 🐛 Bug Report
- ✨ Feature Request
- 📖 Documentation
- ❓ Question

## 📊 Workflows موجود

| Workflow | محرک | عملیات |
|----------|------|--------|
| **Build and Release** | Push to main | ✅ Test → Build → Tag → Release |
| **PR Check** | Pull Request | ✅ Format → Analyze → Test → Build |
| **Manual Release** | دستی | ✅ کنترل کامل نسخه و Release |

## 🎯 Roadmap

- [ ] پشتیبانی از iOS
- [ ] Cloud Sync (Firebase)
- [ ] Export to PDF/CSV
- [ ] یادآوری روزانه
- [ ] پشتیبانی از چند زبان
- [ ] تخمین HbA1c
- [ ] اشتراک‌گذاری با پزشک

## 📄 لایسنس

MIT License - برای اطلاعات بیشتر [LICENSE](LICENSE) را ببینید

## 🙏 تشکر

- [Flutter](https://flutter.dev) - Framework عالی
- [shamsi_date](https://pub.dev/packages/shamsi_date) - پشتیبانی تقویم شمسی
- [fl_chart](https://pub.dev/packages/fl_chart) - نمودارهای زیبا
- [sqflite](https://pub.dev/packages/sqflite) - پایگاه داده محلی

---

**ساخته شده با ❤️ برای جامعه فارسی‌زبان**

⭐ اگر این پروژه برایتان مفید بود، یک ستاره بدهید!
