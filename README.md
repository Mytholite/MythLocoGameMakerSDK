<div align="center">
  <img src="https://mythloco.co.uk/assets/MythLocoLogo.png" alt="MythLoco Logo" width="300">
  
  # MythLoco SDK for GameMaker Studio
  
  **A comprehensive localization system for GameMaker Studio games**
  
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![GameMaker Studio](https://img.shields.io/badge/GameMaker%20Studio-2022%2B-blue)](https://www.yoyogames.com/gamemaker)
  [![Web Tool](https://img.shields.io/badge/Web%20Tool-mythloco.co.uk-green)](https://mythloco.co.uk)
</div>

## ✨ Features

- 🌍 **Multi-language support** - Easily manage translations for multiple languages
- 🔄 **Dynamic language switching** - Change languages at runtime
- 🛡️ **Fallback language support** - Automatic fallback to default language for missing keys
- 🔍 **Comprehensive error handling** - Robust error detection and reporting
- 📝 **Debug logging system** - Detailed logging for development and troubleshooting
- 💾 **Memory-efficient** - Optimized file loading and memory usage
- 🎨 **Web-based editor** - Create and manage translations with the free online tool

## 🚀 Quick Start

### 1. Installation

1. Download the `MythLoco.gml` script and import it into your GameMaker Studio project
2. Create your localization files using the [MythLoco web tool](https://mythloco.co.uk)
3. Add your `.mythloco` project files to "Included Files" in GameMaker Studio

### 2. Basic Setup

```gml
// In your game controller's Create event
if (initMythLoco("localization/game_text.mythloco")) {
    show_debug_message("Localization system ready!");
} else {
    show_debug_message("Failed to initialize localization!");
}

// Get localized text anywhere in your game
var welcome_text = locoGet("ui.welcome_message");
draw_text(x, y, welcome_text);
```

### 3. Language Switching

```gml
// Change language at runtime
if (locoSetLanguage("fr")) {
    show_debug_message("Language changed to French!");
    // Update your UI text here
}

// Get available languages
var languages = locoGetAvailableLanguages();
```

## 🛠️ Creating Localization Files

### Using the Web Tool (Recommended)

1. Visit [mythloco.co.uk](https://mythloco.co.uk)
2. Create a new project and add your languages
3. Add your localization keys and translations
4. **Click "Save Project"** to download the `.mythloco` file
5. Add the file to your GameMaker project's "Included Files"

> **Important:** Use "Save Project" (not "Export Zip") to get the `.mythloco` file format required by this SDK.

### Manual Creation

You can also manually create `.mythloco` files using this JSON structure:

```json
{
  "languages": ["en", "fr", "es"],
  "translations": {
    "en": {
      "game.title": "My Awesome Game",
      "ui.start": "Start Game",
      "ui.options": "Options"
    },
    "fr": {
      "game.title": "Mon Jeu Génial",
      "ui.start": "Commencer",
      "ui.options": "Options"
    },
    "es": {
      "game.title": "Mi Juego Increíble",
      "ui.start": "Iniciar Juego",
      "ui.options": "Opciones"
    }
  }
}
```

## 📚 API Reference

### Core Functions

| Function | Description | Returns |
|----------|-------------|---------|
| `initMythLoco(file_path)` | Initialize the localization system | `bool` |
| `locoGet(key)` | Get localized text by key | `string` |
| `locoSetLanguage(language_code)` | Change current language | `bool` |

### Utility Functions

| Function | Description | Returns |
|----------|-------------|---------|
| `locoGetAvailableLanguages()` | Get array of available languages | `array` |
| `locoGetCurrentLanguage()` | Get current language code | `string` |
| `locoLanguageExists(language_code)` | Check if language exists | `bool` |
| `locoIsInitialized()` | Check if system is initialized | `bool` |

## 🔧 Configuration

```gml
// Enable debug logging
global.debugMythLoco = true;

// Set fallback language (default: "en")
global.locoFallbackLanguage = "en";

// Set text for missing keys (default: "MISSING")
global.locoMissingKeyText = "MISSING";
```

## 📖 Documentation

For comprehensive documentation, examples, and troubleshooting guides, see the included `MythLocoDocumentation.html` file.

## 🎯 Best Practices

- Initialize MythLoco in a persistent object's Create event
- Always check the return value of `initMythLoco()`
- Use consistent naming conventions for localization keys
- Cache frequently used text rather than calling `locoGet()` repeatedly
- Test all languages thoroughly before release

## 🐛 Troubleshooting

### Common Issues

**System fails to initialize:**
- Check file path and ensure file exists in "Included Files"
- Verify JSON syntax is valid
- Enable debug logging: `global.debugMythLoco = true;`

**Missing text appears:**
- Verify the key exists in your localization file
- Check spelling of keys
- Ensure current language has the key defined

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [MythLoco Web Tool](https://mythloco.co.uk) - Free online localization editor
- [GameMaker Studio](https://www.yoyogames.com/gamemaker) - Game development platform
- [Documentation](MythLocoDocumentation.html) - Complete SDK documentation

---

<div align="center">
  <p>Made with ❤️ by <a href="https://mytholite.co.uk">Mytholite</a></p>
</div>
