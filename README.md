# Car Match - Memory Puzzle Mobile App

Car Match is a modern cross-platform memory matching puzzle application built for a university 
assignment (COMP 5450 Mobile Programming, Lakehead University). It features a sleek, high-contrast 
dark theme interface, interactive 3D card-flip perspective transformations, dynamic audio feedback, 
and an optimized particle physics celebration overlay.

## Project Structure

```text
lib/
├── card_model.dart            # Data class and state blueprint for individual cards
├── game_screen.dart           # Main game loop, responsive matrix grid layout, and UI mechanics
├── main.dart                  # Entry point, Material app wrapper, and theme hosting
└── memory_card_widget.dart    # Individual card layout container with 3D Y-axis transform animation
assets/
├── audio/
│   ├── flip.mp3               # UI card flip interaction sound effect
│   ├── match.mp3              # Positive pair match confirmation (engine rev sound)
│   └── victory.mp3            # Full grid completion victory fanfare sound effect
└── images/
    ├── card_back.png          # Uniform back face texture for all cards
    ├── aston_martin.png       # Front face car graphics...
    ├── audi_r8.png
    ├── bugatti.png
    ├── ferrari.png
    ├── lamborghini.png
    ├── mclaren.png
    ├── nissan_gtr.png
    └── porsche.png

How to Open in Android Studio

1. Open Android Studio.

2. Select File > Open.

3. Navigate to your memory_match_car_game root repository directory and click OK.

4. Wait for the IDE to index and sync the workspace.

How to Configure Assets
The application expects 8 sports car front-face images and 1 card-back texture inside the 
assets/images/ folder. All names must be strictly lowercase with underscores separating spaces:

* card_back.png (Default uniform back texture)

* aston_martin.png

* audi_r8.png

* bugatti.png

* ferrari.png

* lamborghini.png

* mclaren.png

* nissan_gtr.png

* porsche.png

Note: If an image asset is missing or incorrectly named, a built-in safe-mode fallback sub-selector 
catches the loading error and safely renders the first three letters of the car name as a text 
token (e.g., "NIS") so the interface remains completely robust and stable.

How to Run

Before running the application for the first time, clean the build tree and fetch dependencies to 
register the asset bundle:

1. Open the Terminal window at the bottom of Android Studio.

2. Run the following command:

Bash
flutter clean && flutter pub get

3. Select your target device/emulator from the device manager dropdown and click the green Run 
triangle button (or run flutter run in the terminal).

Tech Stack

1. Language: Dart

2. UI Framework: Flutter (Material 3)

3. Animation Matrix: Custom 3D perspective affine mapping using Matrix4.identity()..setEntry(3, 2, 
0.002)..rotateY(value)

4. Audio Layer: audioplayers package for low-latency multi-channel interaction streaming

5. Particle FX: confetti physics engine overlay