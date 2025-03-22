# BlueTick - Simple Todo App

A clean, modern todo app built with Flutter featuring an intuitive UI, dark mode support, and smooth animations.

## 📱 Screenshots

<div style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center">
  <img src="assets/images/1.png" width="200" alt="Home Screen">
  <img src="assets/images/2.png" width="200" alt="Task Creation">
  <img src="assets/images/3.png" width="200" alt="Active Tasks">
  <img src="assets/images/4.png" width="200" alt="Completed Tasks">
  <img src="assets/images/5.png" width="200" alt="Dark Mode">
  <img src="assets/images/6.png" width="200" alt="Task Details">
  <img src="assets/images/7.png" width="200" alt="Settings Screen">
</div>

## ✨ Features

- **Task Management**: Add, complete, and delete tasks with ease.
- **Dark Mode**: Toggle between light and dark themes.
- **Animated UI**: Smooth transitions and animations.
- **Local Storage**: Tasks persist between app launches.
- **Gesture Support**: Swipe to delete tasks.
- **Empty State**: Clean interface when no tasks exist.
- **Task Categories**: Separate sections for active and completed tasks.
- **Responsive Design**: Works across various screen sizes.

## 🚀 Getting Started

### Prerequisites

- Flutter (2.0 or newer)
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/bluetick.git
   ```

2. Navigate to the project directory:

   ```bash
   cd bluetick
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

## 🔧 Project Structure

```
lib/
├── main.dart # App entry point
├── models/
│   └── task.dart # Task data model
├── screens/
│   ├── home_screen.dart # Main task list screen
│   └── add_task.dart # New task creation screen
├── widgets/
│   ├── task_tile.dart # Individual task display
│   ├── empty_state.dart # Empty state widget
│   └── app_theme.dart # Theme configuration
└── services/
    └── storage_service.dart # Local data persistence
```

## 🎨 Customization

BlueTick supports extensive customization through the settings menu:

- Change accent colors
- Adjust animation speed
- Configure notification preferences
- Customize task categories

## 🔄 State Management

The app utilizes **Provider** for efficient state management, ensuring smooth performance even with numerous tasks.

## 💾 Storage

Tasks are stored locally using **Hive**, a lightweight and fast NoSQL database solution for Flutter.

## 🛠️ Technologies Used

- Flutter
- Dart
- Provider (State Management)
- Hive (Local Storage)
- Lottie (Animations)

## 📃 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Contact

Your Name - [@yourusername](https://twitter.com/yourusername) - email@example.com

Project Link: [https://github.com/yourusername/bluetick](https://github.com/yourusername/bluetick)
