# 🏗️ معماری پروژه و CI/CD

## 📐 نمای کلی معماری

```
blood_sugar_tracker/
│
├─── 📱 Flutter App (اپلیکیشن)
│    ├── UI Layer (رابط کاربری)
│    ├── Data Layer (لایه داده)
│    └── Database (پایگاه داده محلی)
│
├─── 🤖 CI/CD Pipeline (خط لوله خودکار)
│    ├── Automatic Workflows
│    ├── Manual Workflows
│    └── Helper Scripts
│
└─── 📚 Documentation (مستندات)
     ├── User Guides
     └── Developer Guides
```

---

## 📱 معماری اپلیکیشن

### لایه‌بندی

```
┌─────────────────────────────────────┐
│        UI Layer (Screens)           │
│  ┌──────────┐  ┌───────────────┐   │
│  │  Entry   │  │    Charts     │   │
│  │  Screen  │  │    Screen     │   │
│  └──────────┘  └───────────────┘   │
│         └────────┬────────┘         │
│         ┌────────▼────────┐         │
│         │  Home Screen    │         │
│         │ (Navigation)    │         │
│         └─────────────────┘         │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│      Business Logic Layer           │
│  ┌──────────────────────────────┐  │
│  │  BloodSugarEntry Model       │  │
│  │  - Date handling (Jalali)    │  │
│  │  - Validation                │  │
│  │  - Data transformation       │  │
│  └──────────────────────────────┘  │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│       Data Layer (Database)         │
│  ┌──────────────────────────────┐  │
│  │    DatabaseHelper            │  │
│  │  - SQLite operations         │  │
│  │  - CRUD operations           │  │
│  │  - Query builders            │  │
│  └──────────────────────────────┘  │
│              │                      │
│  ┌───────────▼──────────────────┐  │
│  │   SQLite Database            │  │
│  │   blood_sugar_entries table  │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

### جریان داده

```
User Input → Entry Screen → Validation → DatabaseHelper → SQLite
                                                │
Charts Screen ← Data Processing ← Query ────────┘
```

---

## 🤖 معماری CI/CD

### جریان خودکار (Automatic Flow)

```
┌────────────────────────────────────────────────────────┐
│                   Developer Actions                     │
└───────────────────┬────────────────────────────────────┘
                    │
        ┌───────────▼──────────┐
        │   git commit & push  │
        │   to main/master     │
        └───────────┬──────────┘
                    │
        ┌───────────▼─────────────────────────────────────┐
        │         GitHub Repository (Remote)              │
        └───────────┬─────────────────────────────────────┘
                    │
        ┌───────────▼──────────┐
        │  Webhook Triggered   │
        └───────────┬──────────┘
                    │
┌───────────────────▼──────────────────────────────────────┐
│              GitHub Actions (CI/CD Engine)               │
│                                                           │
│  ┌─────────────────────────────────────────────────┐    │
│  │  Build and Release Workflow                     │    │
│  │                                                  │    │
│  │  1. Checkout Code         ✓                     │    │
│  │  2. Setup Flutter         ✓                     │    │
│  │  3. Get Dependencies      ✓                     │    │
│  │  4. Analyze Code          ✓                     │    │
│  │  5. Run Tests             ✓                     │    │
│  │  6. Calculate Version     ✓ (+0.01)             │    │
│  │  7. Build APK             ✓                     │    │
│  │  8. Build AAB             ✓                     │    │
│  │  9. Commit Version        ✓                     │    │
│  │ 10. Create Git Tag        ✓ (v1.0.X)            │    │
│  │ 11. Create Release        ✓                     │    │
│  │ 12. Upload Artifacts      ✓                     │    │
│  └──────────────────┬──────────────────────────────┘    │
│                     │                                    │
└─────────────────────┼────────────────────────────────────┘
                      │
        ┌─────────────▼──────────────┐
        │   Release Published        │
        │   - Tagged: v1.0.X         │
        │   - APK attached           │
        │   - AAB attached           │
        │   - Release notes          │
        └────────────────────────────┘
```

### جریان Pull Request

```
┌──────────────────┐
│  Feature Branch  │
└────────┬─────────┘
         │ git push
         ▼
┌──────────────────┐
│  Open PR to main │
└────────┬─────────┘
         │ triggers
         ▼
┌─────────────────────────────┐
│    PR Check Workflow        │
│                             │
│  ├─ Check Format            │
│  ├─ Analyze Code            │
│  ├─ Run Tests               │
│  └─ Build Debug             │
└────────┬────────────────────┘
         │
    ┌────▼────┐
    │ Success │─── Ready to Merge
    └─────────┘
         │ Merge to main
         ▼
   Build and Release
   Workflow (خودکار)
```

### جریان دستی (Manual)

```
GitHub UI → Actions Tab → Manual Release
                               │
                    ┌──────────▼───────────┐
                    │  Select version type │
                    │  - patch / minor /   │
                    │    major / custom    │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼────────────┐
                    │   Run Workflow        │
                    │  (same as automatic   │
                    │   but controlled)     │
                    └──────────┬────────────┘
                               │
                    ┌──────────▼────────────┐
                    │  Release Published    │
                    └───────────────────────┘
```

---

## 📊 سیستم Version Management

### الگوریتم افزایش خودکار

```python
# Pseudo-code
def increment_version(current_version):
    major, minor, patch = parse(current_version)
    
    # هر کامیت: +1 به patch
    new_patch = patch + 1
    
    # اگر patch به 100 رسید
    if new_patch >= 100:
        new_minor = minor + 1
        new_patch = 0
        
        # اگر minor به 100 رسید
        if new_minor >= 100:
            new_major = major + 1
            new_minor = 0
            return f"{new_major}.{new_minor}.{new_patch}"
        
        return f"{major}.{new_minor}.{new_patch}"
    
    return f"{major}.{minor}.{new_patch}"

# مثال‌ها:
# 1.0.0   → 1.0.1
# 1.0.99  → 1.1.0
# 1.99.99 → 2.0.0
```

### Build Number

```bash
BUILD_NUMBER = $(git rev-list --count HEAD)
# شمارش کل کامیت‌ها از ابتدای پروژه
# همیشه افزایشی و یکتا
```

---

## 🔄 State Management

### Entry Screen State

```
┌─────────────────────────┐
│   EntryScreen State     │
├─────────────────────────┤
│ - _bloodSugarValue      │
│ - _isFasting            │
│ - _todayEntry           │
│ - _isLoading            │
└───────┬─────────────────┘
        │
        ├─ initState()
        │  └─ _loadTodayEntry()
        │     └─ DatabaseHelper.getTodayEntry()
        │
        ├─ _saveEntry()
        │  └─ DatabaseHelper.insertOrUpdateEntry()
        │     └─ Constraint: ONE per Jalali date
        │
        └─ dispose()
```

### Charts Screen State

```
┌─────────────────────────┐
│   ChartsScreen State    │
├─────────────────────────┤
│ - _entries (List)       │
│ - _isLoading            │
└───────┬─────────────────┘
        │
        ├─ initState()
        │  └─ _loadData()
        │     └─ DatabaseHelper.getEntriesLastMonths(3)
        │
        ├─ _getFastingSpots()
        │  └─ Filter & Transform to FlSpot
        │
        ├─ _getNonFastingSpots()
        │  └─ Filter & Transform to FlSpot
        │
        └─ _calculateStats()
           ├─ Average
           ├─ Max
           └─ Min
```

---

## 🗄️ Database Schema

```sql
CREATE TABLE blood_sugar_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    year INTEGER NOT NULL,           -- سال شمسی
    month INTEGER NOT NULL,          -- ماه شمسی (1-12)
    day INTEGER NOT NULL,            -- روز شمسی (1-31)
    blood_sugar REAL NOT NULL,       -- مقدار قند خون
    is_fasting INTEGER NOT NULL,     -- 1=ناشتا, 0=غیر ناشتا
    timestamp INTEGER NOT NULL,      -- Epoch milliseconds
    UNIQUE(year, month, day)         -- یک ثبت در روز
);

-- Index برای بهبود کارایی
CREATE INDEX idx_date ON blood_sugar_entries(year, month, day);
CREATE INDEX idx_timestamp ON blood_sugar_entries(timestamp);
```

### نمونه داده

```
┌────┬──────┬───────┬─────┬──────────────┬────────────┬──────────────┐
│ id │ year │ month │ day │ blood_sugar  │ is_fasting │  timestamp   │
├────┼──────┼───────┼─────┼──────────────┼────────────┼──────────────┤
│ 1  │ 1403 │   7   │ 11  │    95.5      │     1      │ 1727808000000│
│ 2  │ 1403 │   7   │ 12  │    142.0     │     0      │ 1727894400000│
│ 3  │ 1403 │   7   │ 13  │    88.0      │     1      │ 1727980800000│
└────┴──────┴───────┴─────┴──────────────┴────────────┴──────────────┘
```

---

## 📦 Dependencies Graph

```
blood_sugar_tracker
│
├─ flutter (SDK)
│
├─ UI & Charts
│  ├─ fl_chart (^0.65.0)        # نمودارها
│  └─ cupertino_icons (^1.0.2)  # آیکون‌ها
│
├─ Date & Time
│  ├─ shamsi_date (^1.0.1)      # تقویم شمسی
│  └─ intl (^0.18.1)            # فرمت‌بندی
│
└─ Data Storage
   ├─ sqflite (^2.3.0)          # SQLite
   └─ path (^1.8.3)             # Path utilities
```

---

## 🔐 Security & Permissions

### Android Permissions

```xml
<!-- AndroidManifest.xml -->
<manifest>
    <!-- نیازی به permission خاص ندارد -->
    <!-- فقط برای SQLite محلی -->
</manifest>
```

### Data Privacy

```
✓ داده‌ها فقط روی دستگاه ذخیره می‌شوند
✓ هیچ ارتباط شبکه‌ای ندارد
✓ بدون نیاز به اینترنت کار می‌کند
✓ بدون نیاز به ثبت‌نام یا لاگین
```

---

## 🚀 Performance

### Optimization Points

```
1. Database
   ├─ Index on (year, month, day)
   ├─ Limit queries to 3 months
   └─ Use transactions for batch

2. UI
   ├─ StatefulWidget for reactive updates
   ├─ Lazy loading for charts
   └─ Pull-to-refresh for manual update

3. Build
   ├─ Release mode optimization
   ├─ Minification enabled
   └─ Obfuscation for production
```

---

## 📈 Scalability

### فعلی (Current)

```
- Single device
- Local database
- Manual backup needed
```

### آینده (Future Enhancements)

```
1. Cloud Sync
   └─ Firebase / Supabase

2. Multi-device
   └─ Account-based sync

3. Export/Import
   └─ CSV, PDF reports

4. Reminders
   └─ Daily notifications

5. Analytics
   └─ HbA1c estimation
   └─ Trend analysis

6. Doctor Portal
   └─ Share data with physician
```

---

## 🧪 Testing Strategy

### Unit Tests

```dart
test/
├─ models/
│  └─ blood_sugar_entry_test.dart
├─ database/
│  └─ database_helper_test.dart
└─ utils/
   └─ date_converter_test.dart
```

### Integration Tests

```dart
integration_test/
└─ app_test.dart
   ├─ Test entry flow
   ├─ Test chart rendering
   └─ Test database operations
```

### CI Tests

```yaml
# در workflow:
- name: Run tests
  run: flutter test
```

---

## 📊 Monitoring & Metrics

### GitHub Insights

```
1. Actions Tab
   └─ Workflow runs
   └─ Success/Failure rate
   └─ Build times

2. Releases Tab
   └─ Download counts
   └─ Version history

3. Issues Tab
   └─ Bug reports
   └─ Feature requests
```

### Local Metrics

```bash
# Code metrics
flutter analyze

# Test coverage
flutter test --coverage

# Size analysis
flutter build apk --analyze-size
```

---

## 🔄 Release Cycle

```
Development → Testing → Staging → Production
     │           │          │          │
     │           │          │          └─ main branch
     │           │          └─ release/* branch
     │           └─ develop branch
     └─ feature/* branch

Timeline:
- Feature: 1-3 days
- Bug Fix: < 1 day
- Release: Weekly or on-demand
```

---

## 📞 Support & Maintenance

### Issue Lifecycle

```
Bug Report → Triage → Fix → Test → Deploy → Close
     │          │      │      │      │       │
     │          │      │      │      │       └─ Release notes
     │          │      │      │      └─ Auto-deploy via CI/CD
     │          │      │      └─ PR Check
     │          │      └─ Feature branch
     │          └─ Label & Assign
     └─ GitHub Issue
```

---

## 🎓 Developer Onboarding

### برای توسعه‌دهندگان جدید:

```
1. Clone repo
2. Install Flutter
3. Run `flutter pub get`
4. Read documentation:
   - README.md
   - SETUP.md
   - این فایل
5. Run app: `flutter run`
6. Make changes
7. Create PR
8. CI/CD handles the rest!
```

---

**نسخه**: 1.0.0  
**آخرین بروزرسانی**: 2025-10-02  
**نویسنده**: AI Assistant
