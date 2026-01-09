# Sokrio Users List- Flutter App

A comprehensive Flutter application that allows users to explore Sokrio users with advanced features including search, pagination and data caching. Built using Clean Architecture principles and BLoC state management.
In this project the api key is hidden in (`.env`) file which is added on .(`.gitignore`) because of sicurity concern. App security concern also followed.

## Features ✨

### Architecture
- **Clean Architecture** with proper separation of concerns
- **Repository Pattern** for data access abstraction
- **BLoC Pattern** for state management
- **Dependency Injection** using GetIt
- **API Key Security** hide api key for security using flutter_dotenv

### Home Screen
- **Skeleton Loading** with shimmer effects while loading repositories
- **Search Functionality** with debounced input to search users by first or last name
- **Infinite Pagination** for seamless browsing
- **Pull-to-Refresh** support
- **Local Cache** support
- **Internet Connection Checker** support

### Detail Screen
- **User Avatar** and profile information
- **Name and Email show** and profile information
- **Design** for different screen sizes

### Search
- **Offline and Online Search** support
- **Search State Management** with proper loading and error states

### Error Handling
- **Toast Notifications** for error feedback
- **Retry Logic** for failed network requests
- **Graceful Fallbacks** for offline scenarios
- **User-Friendly Error Messages**

### Navigation
- **Custom Slide Animations** for page transitions
- **Smooth Navigation** between screens

### App Security
- **Hide API Key** in (.env) file for security concern

## Setup Instructions 

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / VS Code with Flutter plugins
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sokrio_flutter_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

4. **Add API Key on `DioClient.dart`**
   ```bash
   # DioClient.dart file
   add api key in Dio headers in 'x-api-key' 
   ```

5. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## Architecture Overview

### Project Structure
```
lib/
├── core/
│   ├── di/                    # Dependency Injection
│   ├── error/                 # Error handling
│   ├── network/               # Conectivity info
│   ├── network_clients/       # Network Client utilities
└── features/
    └── users_list/
        ├── data/
        │   ├── datasources/   # Remote & Local data sources
        │   ├── models/        # Data models
        │   └── repositories/  # Repository implementations
        ├── domain/
        │   ├── entities/      # Business entities
        │   ├── usecases/      # Domain use cases
        │   └── repositories/  # Repository interfaces
        └── presentation/
            ├── bloc/          # BLoC state management
            ├── pages/         # UI screens
            └── widgets/       # Reusable widgets
```

### Clean Architecture Layers

#### 1. **Domain Layer** (Business Logic)
- **Entities**: Core business models (`UserEntity`)
- **Repository Interfaces**: Abstract contracts for data access
- **Use Cases**: Proper Business Logic for Business Case
- **No Dependencies**: Pure Dart with no external dependencies

#### 2. **Data Layer** (Data Sources)
- **Repository Implementations**: Concrete implementations of domain interfaces
- **Data Sources**: Remote (ReqRes API) and Local (SQLite) data sources
- **Models**: Data transfer objects that extend domain entities
- **Network Management**: Internet connectivity checking

#### 3. **Presentation Layer** (UI)
- **BLoC**: State management with events and states
- **Pages**: Screen implementations
- **Widgets**: Reusable UI components

### Key Design Patterns

#### Repository Pattern
- Abstracts data access logic
- Provides single source of truth
- Enables easy testing and mocking
- Handles online/offline scenarios

#### BLoC Pattern
- Unidirectional data flow
- Separation of business logic from UI
- Reactive programming with streams
- Testable and maintainable

#### Dependency Injection
- Loose coupling between components
- Easy testing with mock implementations
- Service locator pattern using GetIt

## Dependencies

### Core Dependencies
```yaml
flutter_bloc: ^9.1.1          # State management
get_it: ^9.2.0               # Dependency injection
dio: ^5.9.0                  # Dio client
dartz: ^0.10.1               # Functional programming
equatable: ^2.0.7            # Value equality
```

### UI & UX Dependencies
```yaml
shimmer: ^3.0.0              # Skeleton loading animations
cached_network_image: ^3.4.1 # Image caching and loading
fluttertoast: ^8.2.8         # Toast notifications
```

### Data & Storage
```yaml
sqflite: ^2.4.2              # Local database
internet_connection_checker: ^3.0.1 # Network connectivity
```

### Utility Dependencies
```yaml
path: ^1.9.1                 # Path utilities
retrofit: ^4.1.0             # Api Client services
json_annotation: ^4.8.1
freezed_annotation: ^3.1.0   # Code Generation for model classes
```

### Generator Builder Dependencies
```yaml
retrofit_generator: ^10.2.0
build_runner: ^2.10.4
freezed: ^3.2.3
json_serializable: ^6.7.1
```

## Performance Optimizations

### Network
- **Pagination**: 10 items per page to reduce memory usage
- **Caching**: Local SQLite database for offline support

### UI
- **Shimmer Loading**: Skeleton screens for better perceived performance
- **Image Caching**: Cached network images with placeholder
- **Lazy Loading**: ListView.builder for efficient memory usage

---

**Built with using Flutter and Clean Architecture**