# 📝 Task Manager App

A clean and minimal **Flutter Task Manager** app that allows users to create, view, edit, and delete tasks with due dates and priorities. Built using **Provider**, **Hive**, and **SharedPreferences**, following clean architecture and Flutter best practices.

---

## 📱 Features

✅ Add new task  
✅ Edit existing task  
✅ Delete task  
✅ View all tasks in a list  

✅ Filter tasks by:
- **Priority:** Low / Medium / High / All
- **Status:** Upcoming / Pending / Completed / All
- **Due Date:** via date picker

✅ Calendar View (Bonus): Visually see upcoming due tasks  
✅ Smooth UI with custom widgets  
✅ Swipe-to-delete with animation  
✅ Animated splash screen (Lottie + Tween)  
✅ Custom app icon/logo  
✅ Local data storage using Hive + SharedPreferences
✅ Shimmer effect on tile  

---

## 🧠 State Management

**Provider** was used for state management due to its:
- Simplicity and ease of integration
- Good documentation and support
- Suitability for small to medium scale apps
- Compatibility with clean architecture and testability

---

## 🏗 Architecture

The app follows **clean architecture** principles with separation of coFncerns:

lib/
├── controller/ # Business logic and state providers
│ ├── splash_provider.dart
│ └── task_controller.dart
│
├── model/ # Task model and Hive adapter
│ ├── task_model.dart
│ └── task_model.g.dart
│
├── service/ # Data storage and preferences
│ ├── shared_pref_service.dart
│ └── task_service.dart
│
├── utils/ # Constants and enums
│ ├── app_text.dart
│ └── priority_enum.dart
│
├── view/ # Screens and UI
│ ├── add_edit_task_screen.dart
│ ├── home_screen.dart
│ └── splash_screen.dart
│
├── widgets/ # Custom reusable widgets
│ ├── custom_button.dart
│ ├── custom_dropdown.dart
│ ├── custom_textfield.dart
│ ├── shimmer_task_tile.dart
│ └── task_tile.dart
│
└── main.dart # App entry point

- **Flutter** – UI Development  
- **Provider** – State Management  
- **Hive** – Local task storage  
- **SharedPreferences** – User preferences  
- **Lottie** – Splash screen animation  
- **Clean Architecture** – Structured codebase

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Emulator or physical device