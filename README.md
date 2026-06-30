# Smart BMI & Health Tracker

Smart BMI is an advanced, premium, and visually stunning wellness dashboard built in Flutter. Moving away from standard text-field calculations, this app provides interactive controls, live animated gauges, local health logs, trend charts, and comprehensive medical indicators (Body Fat %, BMR, TDEE, Ideal Weight Range).

---

## Key Features

- ** Vibe & Dark Mode First**: Modern dark layout utilizing rich teal, indigo, and category-coded wellness colors (cyan, emerald, orange, and crimson).
- **Interactive Radial Gauge**: Custom-painted needle gauge (`BmiGauge`) that sweeps to display the exact BMI value against healthy thresholds.
- **Dynamic Unit Toggler**: Seamless conversion between **Metric** (cm, kg) and **Imperial** (feet/inches, lbs) configurations.
- **Comprehensive Health Analytics**:
  - **Body Fat Percentage**: Calculated using the adult Deurenberg formula:  
    $$\text{BFP} = 1.20 \times \text{BMI} + 0.23 \times \text{Age} - 10.8 \times \text{Gender} - 5.4$$
    *(where Male = 1, Female = 0)*
  - **BMR (Basal Metabolic Rate)**: Daily calorie count using the Mifflin-St Jeor Equation.
  - **TDEE (Total Daily Energy Expenditure)**: Integrated metabolic expenditure adjusted by activity levels (from Sedentary to Extra Active).
  - **Ideal Weight Range**: Bounds derived mathematically based on WHO healthy BMI limits ($18.5$ to $24.9$).
- **History Tracker Dashboard**:
  - **Spline Trend Charts**: Beautiful, interactive charts powered by `fl_chart` allowing you to toggle between Weight and BMI trends over time.
  - **Weight Progress Metrics**: Tracks starting weight, current weight, and net weight loss or gain.
  - **Local Persistence**: Full database replication using `shared_preferences` with swipe-to-delete list records.

---

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK)
- **State Management**: Stateful Widgets with animated controllers
- **Data Storage**: `shared_preferences`
- **Charts & Graphs**: `fl_chart`
- **Utility / Localization**: `intl`

---

## Directory Structure

```text
lib/
├── models/
│   └── bmi_record.dart        # BmiRecord data model & calculations
├── services/
│   └── storage_service.dart   # JSON serialization & SharedPreferences helper
├── widgets/
│   └── gauge_painter.dart     # Custom circular gauge and animated needle
├── screens/ (integrated in root)
│   ├── splash_screen.dart     # Scaling / pulse heart intro logo
│   ├── bmi_screen.dart        # Dynamic input console (sliders & adjusters)
│   ├── result_screen.dart     # Grid metrics, gauge, and suggestions
│   └── history_screen.dart    # Historical trend line graph & logs list
└── main.dart                  # Material 3 unified themes and bootloader
```

---

## Installation & Setup

### Prerequisites
Make sure you have the Flutter SDK installed on your system. You can verify this by running:
```bash
flutter doctor
```

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/mizhab-as/BMI-Calculator.git
   cd BMI-Calculator
   ```
2. Fetch package dependencies:
   ```bash
   flutter pub get
   ```

---

## Running the App

### Quick-Start (Windows)
Double-click the **`run_app.bat`** script in the project root. This launcher automatically checks for the Flutter environment, retrieves all dependencies, lists active emulators/browsers, and launches the application.

### Manual CLI Start
To compile and execute the project manually, run:
```bash
flutter run
```
To run specifically on Web browsers:
```bash
flutter run -d chrome
```
To run on desktop Windows:
```bash
flutter run -d windows
```

---

## CI/CD & Live Deployment (Automated)

We have configured a fully automated build and deploy pipeline via **GitHub Actions** in [.github/workflows/build_and_deploy.yml](file:///c:/Users/admin/Documents/Project/Smart%20BMI/.github/workflows/build_and_deploy.yml).

Every time code is pushed to the `main` branch, the pipeline will:
1. **Build the Android APK**: Automatically compiles the app into a release APK and uploads it to your GitHub Action Run. Anyone can download this APK directly to their Android phone!
2. **Build & Deploy Flutter Web**: Automatically builds the Flutter web assets and deploys them to **GitHub Pages** so everyone can see the app running live.

### How to access the APK:
1. Go to your repository on GitHub: `https://github.com/mizhab-as/BMI-Calculator`
2. Click on the **Actions** tab.
3. Select the latest workflow run (e.g., "Build and Deploy Smart BMI").
4. Scroll down to the **Artifacts** section at the bottom of the page and click **Smart-BMI-Android-APK** to download!

### How to configure GitHub Pages (First time only):
1. In your GitHub repository, click on **Settings** (gear icon).
2. On the left sidebar, click **Pages** (under the "Code and automation" section).
3. Under "Build and deployment", set the source to **Deploy from a branch**.
4. Set the branch to **`gh-pages`** and the folder to **`/ (root)`**, then click **Save**.
5. Your live app will be available online at `https://mizhab-as.github.io/BMI-Calculator/`!
