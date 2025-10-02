# راهنمای جامع CI/CD و Workflow

## 📋 فهرست

1. [نمای کلی](#نمای-کلی)
2. [Workflows موجود](#workflows-موجود)
3. [سیستم نسخه‌گذاری](#سیستم-نسخهگذاری)
4. [تنظیمات اولیه](#تنظیمات-اولیه)
5. [نحوه استفاده](#نحوه-استفاده)
6. [اسکریپت‌های کمکی](#اسکریپتهای-کمکی)
7. [عیب‌یابی](#عیبیابی)

---

## نمای کلی

این پروژه دارای سیستم CI/CD کامل است که:

✅ **به صورت خودکار**:
- کد را تست و آنالیز می‌کند
- نسخه را افزایش می‌دهد (هر کامیت = +0.01)
- APK و App Bundle می‌سازد
- تگ Git ایجاد می‌کند
- Release در GitHub منتشر می‌کند

✅ **برای هر Pull Request**:
- فرمت کد را بررسی می‌کند
- تست‌ها را اجرا می‌کند
- بیلد را چک می‌کند

✅ **به صورت دستی**:
- امکان انتخاب نوع افزایش نسخه
- امکان تعیین نسخه سفارشی
- کنترل کامل بر روند Release

---

## Workflows موجود

### 1️⃣ Build and Release (`build-and-release.yml`)

**محرک**: Push به `main` یا `master`

**مراحل**:
```
1. Checkout کد
2. نصب Flutter
3. نصب dependencies
4. آنالیز و تست کد
5. محاسبه و افزایش نسخه (+0.01)
6. ساخت APK و AAB
7. کامیت نسخه جدید
8. ایجاد تگ Git
9. انتشار Release
10. آپلود Artifacts
```

**خروجی**:
- Release جدید در GitHub
- تگ Git با فرمت `v1.0.X`
- فایل‌های APK و AAB قابل دانلود
- Artifacts در Actions

**مثال**:
```bash
git commit -m "feat: add new chart"
git push origin main
# → نسخه 1.0.0 به 1.0.1 افزایش می‌یابد
```

---

### 2️⃣ PR Check (`pr-check.yml`)

**محرک**: Pull Request به `main` یا `master`

**مراحل**:
```
1. Checkout کد PR
2. نصب Flutter
3. بررسی فرمت کد (dart format)
4. آنالیز کد (flutter analyze)
5. اجرای تست‌ها
6. بیلد Debug
```

**هدف**: اطمینان از کیفیت کد قبل از Merge

**مثال**:
```bash
git checkout -b feature/new-feature
git commit -m "feat: add feature"
git push origin feature/new-feature
# → باز کردن PR
# → Workflow به صورت خودکار اجرا می‌شود
```

---

### 3️⃣ Manual Release (`manual-release.yml`)

**محرک**: دستی از GitHub UI

**ورودی‌ها**:
- `version_type`: patch / minor / major
- `custom_version`: نسخه دلخواه (اختیاری)

**مراحل**:
```
1. دریافت ورودی‌های کاربر
2. محاسبه نسخه جدید
3. تست و ساخت
4. کامیت و تگ
5. انتشار Release
```

**استفاده**:
1. GitHub → Actions → Manual Release
2. Run workflow
3. انتخاب نوع یا وارد کردن نسخه
4. Run
5. منتظر بمانید تا Release منتشر شود

---

## سیستم نسخه‌گذاری

### فرمت

```
MAJOR.MINOR.PATCH+BUILD
  1  .  0  .  15  + 47
  │    │    │      └─ تعداد کامیت‌ها
  │    │    └─ تغییرات جزئی (0-99)
  │    └─ ویژگی‌های جدید (0-99)
  └─ تغییرات بزرگ
```

### قوانین افزایش خودکار

#### Patch (+0.01)
```
1.0.0 → 1.0.1 → 1.0.2 → ... → 1.0.99 → 1.1.0
```
- هر کامیت در main/master
- Bug fixes
- تغییرات جزئی

#### Minor (+0.1) - دستی
```
1.0.0 → 1.1.0 → 1.2.0 → ... → 1.99.0 → 2.0.0
```
- ویژگی‌های جدید
- تغییرات قابل توجه
- Backward compatible

#### Major (+1.0) - دستی
```
1.0.0 → 2.0.0 → 3.0.0
```
- تغییرات بزرگ
- Breaking changes
- بازطراحی

### Build Number

```bash
BUILD_NUMBER=$(git rev-list --count HEAD)
```
- تعداد کامیت‌ها از اول پروژه
- همیشه افزایش می‌یابد
- یکتا برای هر بیلد

---

## تنظیمات اولیه

### 1. تنظیمات Repository

#### A. Workflow Permissions

```
Settings → Actions → General → Workflow permissions
```

✅ **انتخاب کنید**:
- [x] Read and write permissions
- [x] Allow GitHub Actions to create and approve pull requests

#### B. Actions

```
Settings → Actions → General → Actions permissions
```

✅ **فعال کنید**:
- [x] Allow all actions and reusable workflows

### 2. Branch Protection (اختیاری اما توصیه می‌شود)

```
Settings → Branches → Add rule
```

**برای `main` یا `master`**:
- [x] Require a pull request before merging
- [x] Require status checks to pass before merging
  - Status checks: `check`
- [x] Do not allow bypassing the above settings

### 3. Secrets (برای Production)

```
Settings → Secrets and variables → Actions
```

**برای Google Play Store**:
```
KEYSTORE_PASSWORD: رمز keystore
KEY_PASSWORD: رمز key
KEY_ALIAS: نام alias
KEYSTORE_FILE: محتوای base64 keystore
```

---

## نحوه استفاده

### سناریو 1: توسعه روزمره

```bash
# ایجاد feature branch
git checkout -b feature/blood-sugar-filter

# توسعه و کامیت
git add .
git commit -m "feat: add filter for blood sugar entries"
git push origin feature/blood-sugar-filter

# باز کردن PR
# → Workflow PR Check اجرا می‌شود
# → بررسی می‌شود که همه چیز OK است

# بعد از تایید، Merge کنید
# → Workflow Build and Release اجرا می‌شود
# → نسخه 1.0.5 → 1.0.6
# → Release جدید منتشر می‌شود
```

### سناریو 2: Bug Fix سریع

```bash
# مستقیماً در main
git checkout main
git pull

# اصلاح bug
vim lib/screens/entry_screen.dart
git add .
git commit -m "fix: resolve date picker issue"
git push origin main

# → خودکار: نسخه +0.01
# → خودکار: Release جدید
```

### سناریو 3: Release بزرگ

```bash
# توسعه در branch
git checkout -b release/v1.1.0
# ... تغییرات زیاد ...
git commit -m "feat: major UI redesign"
git push

# Merge به main
git checkout main
git merge release/v1.1.0
git push

# سپس Manual Release
# GitHub → Actions → Manual Release
# version_type: minor
# → نسخه 1.0.99 → 1.1.0
```

### سناریو 4: کامیت بدون Release

```bash
# برای docs یا changes غیرمهم
git commit -m "docs: update README [skip ci]"
git push

# → Workflow اجرا نمی‌شود
# → نسخه افزایش نمی‌یابد
```

---

## اسکریپت‌های کمکی

### 1. Version Management (`scripts/version.sh`)

**استفاده**:
```bash
chmod +x scripts/version.sh
./scripts/version.sh
```

**خروجی**:
```
📦 Version Management Script
==============================
Current version: 1.0.5

Select increment type:
1) Patch (+0.01)  - مثال: 1.0.0 -> 1.0.1
2) Minor (+0.1)   - مثال: 1.0.0 -> 1.1.0
3) Major (+1)     - مثال: 1.0.0 -> 2.0.0
4) Custom version
Enter choice (1-4):
```

### 2. Build Release (`scripts/build-release.sh`)

**استفاده**:
```bash
chmod +x scripts/build-release.sh
./scripts/build-release.sh
```

**خروجی**:
```
🔨 Building Release Artifacts
===============================
Version: 1.0.5
Build: 47

🧹 Cleaning previous builds...
📱 Building APK...
📦 Building App Bundle...

✅ Build completed successfully!

Output files:
  APK: build/app/outputs/flutter-apk/app-release.apk
  AAB: build/app/outputs/bundle/release/app-release.aab

APK Size: 18M
AAB Size: 15M
```

---

## عیب‌یابی

### ❌ Workflow اجرا نمی‌شود

**علت‌های احتمالی**:
1. Actions غیرفعال است
2. Permissions کافی نیست
3. Branch name اشتباه است

**راه‌حل**:
```bash
# 1. چک کنید Actions فعال است
Settings → Actions → Allow all actions

# 2. چک کنید Permissions
Settings → Actions → Workflow permissions → Read and write

# 3. نام branch را بررسی کنید
git branch  # باید main یا master باشد
```

### ❌ Build شکست می‌خورد

**چک کنید**:
```bash
# 1. Dependencies
flutter pub get

# 2. آنالیز محلی
flutter analyze

# 3. تست محلی
flutter test

# 4. بیلد محلی
flutter build apk --release
```

**Logs را بررسی کنید**:
```
GitHub → Actions → Failed workflow → جزئیات
```

### ❌ نسخه افزایش نمی‌یابد

**علت‌های احتمالی**:
1. کامیت دارای `[skip ci]` است
2. Push به branch دیگری است (نه main)
3. pubspec.yaml مشکل دارد

**راه‌حل**:
```bash
# 1. کامیت را بدون [skip ci] بزنید
git commit --amend -m "feat: new feature"

# 2. به main push کنید
git checkout main
git merge feature-branch
git push origin main

# 3. pubspec.yaml را بررسی کنید
grep "version:" pubspec.yaml
# باید فرمت: version: 1.0.0+1 باشد
```

### ❌ Permission denied

**خطا**:
```
remote: Permission to user/repo.git denied
```

**راه‌حل**:
```bash
# در Workflow، token را صحیح تنظیم کنید
with:
  token: ${{ secrets.GITHUB_TOKEN }}

# و Permissions را فعال کنید
Settings → Actions → Workflow permissions
```

### ❌ Release ایجاد نمی‌شود

**چک کنید**:
```bash
# 1. تگ موجود است؟
git tag -l

# 2. فایل‌های build موجود هستند؟
ls -la build/app/outputs/flutter-apk/
ls -la build/app/outputs/bundle/release/

# 3. Workflow log
# بررسی کنید step "Create Release" چه می‌گوید
```

---

## نکات پیشرفته

### کار با Git Flow

```bash
# Development branch
git checkout -b develop

# Feature branches
git checkout -b feature/new-feature develop

# بعد از اتمام
git checkout develop
git merge --no-ff feature/new-feature
git push origin develop

# Release branch
git checkout -b release/1.1.0 develop
# ... تست و fix bugs ...
git checkout main
git merge --no-ff release/1.1.0
git tag -a v1.1.0
git push origin main --tags
```

### Custom Workflow

می‌توانید Workflow سفارشی اضافه کنید:

```yaml
# .github/workflows/custom.yml
name: Custom Workflow

on:
  schedule:
    - cron: '0 0 * * 0'  # هر هفته

jobs:
  custom-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # ... your steps
```

### Notification در Telegram

```yaml
- name: Send Telegram notification
  if: success()
  uses: appleboy/telegram-action@master
  with:
    to: ${{ secrets.TELEGRAM_TO }}
    token: ${{ secrets.TELEGRAM_TOKEN }}
    message: |
      ✅ Build successful!
      Version: ${{ steps.version.outputs.version }}
      Download: ${{ github.server_url }}/${{ github.repository }}/releases
```

---

## چک‌لیست راه‌اندازی

قبل از استفاده، مطمئن شوید:

- [ ] Repository در GitHub ایجاد شده
- [ ] Branch اصلی `main` یا `master` نام دارد
- [ ] Actions فعال است
- [ ] Workflow permissions تنظیم شده
- [ ] pubspec.yaml فرمت صحیح دارد (version: 1.0.0+1)
- [ ] اولین کامیت زده شده
- [ ] Workflows در `.github/workflows/` موجود هستند
- [ ] اسکریپت‌ها executable هستند (`chmod +x`)

---

## منابع

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD](https://docs.flutter.dev/deployment/cd)
- [Semantic Versioning](https://semver.org/)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)

---

**نسخه این مستند**: 1.0.0  
**آخرین بروزرسانی**: 2025-10-02
