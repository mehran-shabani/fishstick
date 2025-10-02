# راهنمای انتشار نسخه (Release Guide)

## 🤖 انتشار خودکار (Automatic Release)

هر بار که تغییراتی را به برنچ `main` یا `master` کامیت (commit) می‌کنید:

1. **نسخه به صورت خودکار افزایش می‌یابد** (0.01+ به patch version)
   - مثال: `1.0.0` → `1.0.1` → `1.0.2` ... → `1.1.0`

2. **برنامه به صورت خودکار ساخته می‌شود**:
   - APK اندروید
   - App Bundle اندروید

3. **تگ Git به صورت خودکار ایجاد می‌شود**:
   - فرمت: `v1.0.1`

4. **Release در GitHub به صورت خودکار منتشر می‌شود**:
   - شامل فایل‌های APK و AAB
   - شامل یادداشت‌های نسخه

### مثال Workflow:

```bash
git add .
git commit -m "feat: add new feature"
git push origin main
# ↓ نسخه جدید به صورت خودکار منتشر می‌شود
```

---

## 🎯 انتشار دستی (Manual Release)

### از طریق GitHub Actions:

1. به GitHub Repository بروید
2. به تب **Actions** بروید
3. **Manual Release** را انتخاب کنید
4. روی **Run workflow** کلیک کنید
5. نوع نسخه را انتخاب کنید:
   - `patch`: افزایش 0.01 (1.0.0 → 1.0.1)
   - `minor`: افزایش 0.1 (1.0.0 → 1.1.0)
   - `major`: افزایش 1 (1.0.0 → 2.0.0)
6. یا نسخه سفارشی وارد کنید

### از طریق Script:

```bash
# استفاده از اسکریپت
./scripts/version.sh

# یا مستقیماً بیلد بگیرید
./scripts/build-release.sh
```

---

## 📊 سیستم نسخه‌گذاری

### فرمت نسخه:
```
MAJOR.MINOR.PATCH+BUILD_NUMBER
مثال: 1.2.15+47
```

### قوانین افزایش:

- **PATCH** (0.01): تغییرات جزئی، bug fixes
  - `1.0.0` → `1.0.1` → ... → `1.0.99` → `1.1.0`

- **MINOR** (0.1): ویژگی‌های جدید، تغییرات متوسط
  - `1.0.0` → `1.1.0` → ... → `1.99.0` → `2.0.0`

- **MAJOR** (1.0): تغییرات بزرگ، breaking changes
  - `1.0.0` → `2.0.0` → `3.0.0`

- **BUILD_NUMBER**: تعداد کامیت‌ها از ابتدا

### مثال‌ها:

```bash
# شروع
1.0.0+1

# بعد از 5 کامیت
1.0.5+6

# بعد از 99 کامیت
1.0.99+100

# بعد از 100 کامیت (اتوماتیک minor افزایش می‌یابد)
1.1.0+101

# بعد از رسیدن به 1.99.99
2.0.0+...
```

---

## 🔄 Workflows موجود

### 1. Build and Release (خودکار)
- **محرک**: Push به main/master
- **عملیات**:
  - تست و آنالیز کد
  - افزایش خودکار نسخه
  - ساخت APK و AAB
  - کامیت نسخه جدید
  - ایجاد تگ
  - انتشار Release

### 2. PR Check
- **محرک**: Pull Request
- **عملیات**:
  - بررسی فرمت کد
  - آنالیز کد
  - اجرای تست‌ها
  - بررسی بیلد

### 3. Manual Release
- **محرک**: دستی از UI
- **عملیات**:
  - انتخاب نوع نسخه
  - تست و ساخت
  - انتشار Release

---

## 📦 فایل‌های خروجی

بعد از هر Release:

### APK (Android Package)
```
build/app/outputs/flutter-apk/app-release.apk
```
- برای نصب مستقیم
- قابل اشتراک‌گذاری
- نیاز به فعال کردن "منابع ناشناخته"

### AAB (Android App Bundle)
```
build/app/outputs/bundle/release/app-release.aab
```
- برای Google Play Store
- بهینه‌سازی شده
- فرمت توصیه شده Google

---

## 🚀 نکات مهم

### ❗ برای کامیت‌های بدون نیاز به Release:
اگر نمی‌خواهید کامیتی باعث افزایش نسخه شود، `[skip ci]` اضافه کنید:

```bash
git commit -m "docs: update README [skip ci]"
```

### ❗ تنظیمات مورد نیاز:

1. **Repository Permissions**:
   - Settings → Actions → General
   - Workflow permissions: "Read and write permissions"
   - ✅ Allow GitHub Actions to create and approve pull requests

2. **Branch Protection** (اختیاری):
   - Require pull request reviews
   - Require status checks

### ❗ Signing برای Release:

برای انتشار در Google Play، نیاز به Signing است:

```bash
# کلید ایجاد کنید
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# در android/key.properties ذخیره کنید
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

---

## 📝 Changelog

نسخه‌ها:

- **1.0.0** - نسخه اولیه
  - سیستم ثبت قند خون
  - تقویم شمسی
  - نمودارهای جداگانه
  - ذخیره محلی

---

## 🆘 عیب‌یابی

### Workflow اجرا نمی‌شود:
- بررسی کنید Actions فعال باشد
- Permissions را چک کنید
- Branch name را تأیید کنید (main یا master)

### Build شکست می‌خورد:
- وابستگی‌ها را بررسی کنید
- Flutter version را چک کنید
- Logs را مطالعه کنید

### نسخه افزایش نمی‌یابد:
- کامیت‌های با `[skip ci]` نادیده گرفته می‌شوند
- فقط در main/master اتفاق می‌افتد
- pubspec.yaml را بررسی کنید

---

## 📞 پشتیبانی

برای مشکلات و سوالات:
- Issues را در GitHub باز کنید
- Workflow logs را بررسی کنید
- Documentation را مطالعه کنید
