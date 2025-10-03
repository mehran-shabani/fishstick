# 🚀 راهنمای راه‌اندازی سریع

## 📦 آنچه در این پروژه وجود دارد

### 1. اپلیکیشن Flutter
- ✅ ثبت قند خون با تقویم شمسی
- ✅ یک ثبت در روز
- ✅ نمودارهای جداگانه (ناشتا / غیر ناشتا)
- ✅ ذخیره‌سازی محلی با SQLite
- ✅ رابط کاربری فارسی و زیبا

### 2. سیستم CI/CD کامل
- ✅ Workflow خودکار برای Build و Release
- ✅ Workflow بررسی Pull Request
- ✅ Workflow دستی برای Release
- ✅ نسخه‌گذاری خودکار (+0.01 در هر کامیت)
- ✅ تگ‌گذاری خودکار Git
- ✅ انتشار خودکار Release در GitHub

### 3. ابزارهای کمکی
- ✅ اسکریپت مدیریت نسخه
- ✅ اسکریپت ساخت Release
- ✅ مستندات جامع

---

## ⚡ راه‌اندازی در 5 دقیقه

### مرحله 1: تنظیمات GitHub (یکبار)

#### A. فعال‌سازی Actions
```
1. به Settings بروید
2. Actions → General
3. Actions permissions: "Allow all actions and reusable workflows"
4. Workflow permissions: "Read and write permissions"
5. ✅ Allow GitHub Actions to create and approve pull requests
6. Save
```

#### B. تنظیم Branch
```bash
# مطمئن شوید branch اصلی main یا master است
git branch -m main  # اگر نیست، تغییر نام دهید
git push -u origin main
```

### مرحله 2: اولین استفاده

```bash
# 1. Clone کردن (اگر هنوز نکرده‌اید)
git clone <your-repo-url>
cd blood_sugar_tracker

# 2. نصب Flutter dependencies
flutter pub get

# 3. تست محلی
flutter analyze
flutter test

# 4. اولین کامیت و Push
git add .
git commit -m "feat: initial setup with CI/CD"
git push origin main

# ✨ تمام! Workflow خودکاً اجرا می‌شود
```

### مرحله 3: بررسی نتیجه

```
1. به GitHub Repository بروید
2. تب Actions → مشاهده workflow در حال اجرا
3. بعد از اتمام، تب Releases → Release جدید را ببینید!
4. فایل‌های APK و AAB قابل دانلود هستند
```

---

## 📱 استفاده روزمره

### سناریو 1: اضافه کردن ویژگی جدید

```bash
# 1. ایجاد branch
git checkout -b feature/new-feature

# 2. توسعه
# ... edit files ...

# 3. کامیت و Push
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature

# 4. باز کردن Pull Request
# → Workflow PR Check اجرا می‌شود

# 5. بعد از تایید، Merge کنید
# → Workflow Build and Release اجرا می‌شود
# → نسخه خودکار +0.01 می‌شود
# → Release جدید منتشر می‌شود
```

### سناریو 2: Bug Fix سریع

```bash
git checkout main
git pull
# ... fix bug ...
git add .
git commit -m "fix: resolve issue #123"
git push origin main

# → خودکار: نسخه +0.01
# → خودکار: Release جدید
```

### سناریو 3: تغییرات Documentation

```bash
# برای تغییراتی که نیازی به Release ندارند
git commit -m "docs: update README [skip ci]"
git push

# → Workflow اجرا نمی‌شود
```

---

## 🎯 نسخه‌گذاری

### خودکار (در هر کامیت به main)
```
1.0.0 → 1.0.1 → 1.0.2 → ... → 1.0.99 → 1.1.0 → ... → 2.0.0
هر کامیت = +0.01
```

### دستی (از GitHub UI)
```
GitHub → Actions → Manual Release → Run workflow
```

انتخاب کنید:
- **Patch**: +0.01 (برای bug fixes)
- **Minor**: +0.1 (برای ویژگی‌های جدید)
- **Major**: +1.0 (برای تغییرات بزرگ)

یا نسخه سفارشی وارد کنید: `2.5.10`

### از Terminal
```bash
./scripts/version.sh
# منوی تعاملی را دنبال کنید
```

---

## 🔧 ساخت محلی

### Build APK
```bash
flutter build apk --release
# خروجی: build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (برای Google Play)
```bash
flutter build appbundle --release
# خروجی: build/app/outputs/bundle/release/app-release.aab
```

### استفاده از Script
```bash
./scripts/build-release.sh
# ساخت هر دو فایل APK و AAB
```

---

## 📊 ساختار Workflows

### 1. Build and Release (خودکار)
```
Trigger: Push to main/master
├─ Analyze & Test
├─ Version +0.01
├─ Build APK & AAB
├─ Commit version
├─ Create Git tag
└─ Create GitHub Release
```

### 2. PR Check (خودکار)
```
Trigger: Pull Request
├─ Check format
├─ Analyze code
├─ Run tests
└─ Build debug
```

### 3. Manual Release (دستی)
```
Trigger: Manual from GitHub UI
├─ Choose version type
├─ Test & Build
├─ Create tag
└─ Publish release
```

---

## 🛠️ فایل‌های مهم

### Workflows
```
.github/workflows/
├── build-and-release.yml   # خودکار: Build + Release
├── pr-check.yml             # خودکار: بررسی PR
└── manual-release.yml       # دستی: Release
```

### Scripts
```
scripts/
├── version.sh               # مدیریت نسخه
└── build-release.sh         # ساخت Release
```

### Documentation
```
├── README.md                # توضیحات اپلیکیشن
├── RELEASE.md               # راهنمای Release
├── SETUP.md                 # این فایل
└── .github/WORKFLOW_GUIDE.md # راهنمای جامع Workflows
```

### Configuration
```
├── pubspec.yaml             # Dependencies + Version
├── analysis_options.yaml    # Lint rules
└── .gitignore               # Git ignore
```

---

## ✅ چک‌لیست راه‌اندازی

قبل از شروع، اطمینان حاصل کنید:

- [ ] Flutter SDK نصب شده (3.0.0+)
- [ ] Git نصب و تنظیم شده
- [ ] Repository در GitHub ایجاد شده
- [ ] Branch اصلی `main` یا `master` است
- [ ] GitHub Actions فعال است
- [ ] Workflow permissions تنظیم شده (Read and write)
- [ ] اولین push انجام شده

بررسی سریع:
```bash
flutter --version          # باید 3.0+ باشد
git --version              # باید نصب باشد
git remote -v              # باید GitHub repo را نشان دهد
git branch                 # باید main یا master باشد
```

---

## 🆘 مشکلات متداول

### ❌ "flutter: command not found"
```bash
# Flutter نصب نیست یا در PATH نیست
# دانلود و نصب Flutter:
# https://docs.flutter.dev/get-started/install
```

### ❌ Workflow اجرا نمی‌شود
```
Settings → Actions → فعال کردن Actions
Settings → Actions → Workflow permissions → Read and write
```

### ❌ "Permission denied" در GitHub
```
Settings → Actions → General
✅ Read and write permissions
✅ Allow GitHub Actions to create and approve pull requests
```

### ❌ Build شکست می‌خورد
```bash
# محلی تست کنید:
flutter clean
flutter pub get
flutter analyze
flutter build apk --debug

# Logs در GitHub:
Actions → Failed workflow → View details
```

---

## 📚 مستندات بیشتر

- **راهنمای کامل Workflows**: `.github/WORKFLOW_GUIDE.md`
- **راهنمای Release**: `RELEASE.md`
- **راهنمای اپلیکیشن**: `README.md`

---

## 🎉 شروع کنید!

```bash
# همه چیز آماده است!
# فقط کد بزنید و push کنید

git add .
git commit -m "feat: your awesome feature"
git push origin main

# ✨ بقیه کارها خودکار است!
```

---

## 🔗 لینک‌های مفید

- [Flutter Documentation](https://docs.flutter.dev/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Shamsi Date Package](https://pub.dev/packages/shamsi_date)
- [FL Chart Package](https://pub.dev/packages/fl_chart)
- [SQLite Package](https://pub.dev/packages/sqflite)

---

**موفق باشید! 🚀**

در صورت هرگونه سوال یا مشکل، Issue باز کنید.
