// ================================================================================
// MythLoco Localization SDK v1.1
// ================================================================================
// A comprehensive localization system for GameMaker Studio
// 
// SETUP:
// 1. Call initMythLoco("path/to/your/file.mythloco") once at game start
// 2. Use locoGet("key_name") to retrieve localized text
// 3. Use locoSetLanguage("language_code") to change languages
//
// FILE FORMAT (.mythloco):
// {
//   "languages": ["en", "fr", "es"],
//   "translations": {
//     "en": { "hello": "Hello", "goodbye": "Goodbye" },
//     "fr": { "hello": "Bonjour", "goodbye": "Au revoir" }
//   }
// }
// ================================================================================

/// Configuration ////////////////////////////////////////////////////////////////
global.debugMythLoco = true;          // Set to true for debug output
global.locoFallbackLanguage = "en";    // Fallback language if key not found
global.locoMissingKeyText = "MISSING"; // Text shown for missing keys
//////////////////////////////////////////////////////////////////////////////////

/// @function locoLog(message, [force])
/// @description Internal logging function for MythLoco system
/// @param {string} message - The message to log
/// @param {bool} [force=false] - Force logging even when debug is disabled
function locoLog(_message, _force = false) {
    if (global.debugMythLoco || _force) {
        show_debug_message($"[MYTHLOCO] {_message}");
    }
}

/// @function initMythLoco(file_path, [default_language])
/// @description Initialize the MythLoco localization system
/// @param {string} file_path - Path to the .mythloco file (should be in Included Files)
/// @param {string} [default_language="en"] - Default language code to use
/// @returns {bool} Returns true on success, false on failure
/// @example
/// // Initialize with default English
/// initMythLoco("localization/game_text.mythloco");
/// 
/// // Initialize with specific language
/// initMythLoco("localization/game_text.mythloco", "fr");
function initMythLoco(_file_path, _default_language = "en") {
    locoLog("Initializing MythLoco Localization System...");
    
    // Reset globals
    global.lang = _default_language;
    global.loco = undefined;
    
    // Load the localization file
    global.loco = LoadMythLoco(_file_path);
    
    if (global.loco == undefined) {
        locoLog("ERROR: MythLoco initialization failed!", true);
        return false;
    }
    
    // Validate the loaded data
    if (!validateMythLocoData(global.loco)) {
        locoLog("ERROR: Invalid .mythloco file format!", true);
        global.loco = undefined;
        return false;
    }
    
    // Check if requested language exists
    if (!locoLanguageExists(_default_language)) {
        locoLog($"WARNING: Language '{_default_language}' not found. Using first available language.", true);
        var _available_languages = global.loco.languages;
        if (array_length(_available_languages) > 0) {
            global.lang = _available_languages[0];
        }
    }
    
    locoLog($"SUCCESS: MythLoco initialized with language '{global.lang}'");
    locoLog($"Available languages: {string(global.loco.languages)}");
    
    return true;
}

/// @function LoadMythLoco(file_path)
/// @description Load and parse a .mythloco file
/// @param {string} file_path - Path to the .mythloco file
/// @returns {struct|undefined} Parsed localization data or undefined on failure
function LoadMythLoco(_file_path) {
    // Check if file exists
    if (!file_exists(_file_path)) {
        locoLog($"ERROR: File not found - {_file_path}", true);
        return undefined;
    }
    
    // Load file into buffer
    var _buffer = buffer_load(_file_path);
    if (_buffer == -1) {
        locoLog($"ERROR: Failed to load file - {_file_path}", true);
        return undefined;
    }
    
    var _size = buffer_get_size(_buffer);
    var _json_string = "";
    
    // Convert buffer to string, skipping null bytes
    for (var i = 0; i < _size; i++) {
        var _byte = buffer_peek(_buffer, i, buffer_u8);
        if (_byte != 0) {
            _json_string += chr(_byte);
        }
    }
    
    // Clean up buffer memory
    buffer_delete(_buffer);
    
    // Parse JSON
    var _result;
    try {
        _result = json_parse(_json_string);
    } catch (_exception) {
        locoLog($"ERROR: JSON parse error - {_exception.message}", true);
        return undefined;
    }
    
    return _result;
}

/// @function validateMythLocoData(data)
/// @description Validate the structure of loaded MythLoco data
/// @param {struct} data - The loaded localization data
/// @returns {bool} True if valid, false otherwise
function validateMythLocoData(_data) {
    if (!is_struct(_data)) {
        locoLog("ERROR: Root data is not a struct", true);
        return false;
    }
    
    if (!struct_exists(_data, "languages") || !struct_exists(_data, "translations")) {
        locoLog("ERROR: Missing required fields 'languages' or 'translations'", true);
        return false;
    }
    
    if (!is_array(_data.languages)) {
        locoLog("ERROR: 'languages' field must be an array", true);
        return false;
    }
    
    if (!is_struct(_data.translations)) {
        locoLog("ERROR: 'translations' field must be a struct", true);
        return false;
    }
    
    return true;
}

/// @function locoGet(key, [language])
/// @description Retrieve localized text by key
/// @param {string} key - The localization key to retrieve
/// @param {string} [language] - Optional language override (uses current language if not specified)
/// @returns {string} The localized text or fallback text if not found
/// @example
/// var greeting = locoGet("hello");              // Get "hello" in current language
/// var french_goodbye = locoGet("goodbye", "fr"); // Get "goodbye" in French
function locoGet(_key, _language = global.lang) {
    locoLog($"Retrieving key: '{_key}' for language: '{_language}'");
    
    // Check if system is initialized
    if (global.loco == undefined) {
        locoLog("ERROR: MythLoco not initialized! Call initMythLoco() first.", true);
        return global.locoMissingKeyText;
    }
    
    var _translations = global.loco.translations;
    
    // Try to get translation for requested language
    var _lang_data = struct_get(_translations, _language);
    if (_lang_data != undefined && struct_exists(_lang_data, _key)) {
        locoLog($"Found key: '{_key}' in language: '{_language}'");
        return struct_get(_lang_data, _key);
    }
    
    // Try fallback language if different from requested
    if (_language != global.locoFallbackLanguage) {
        locoLog($"Key '{_key}' not found in '{_language}', trying fallback language '{global.locoFallbackLanguage}'");
        var _fallback_data = struct_get(_translations, global.locoFallbackLanguage);
        if (_fallback_data != undefined && struct_exists(_fallback_data, _key)) {
            locoLog($"Found key: '{_key}' in fallback language: '{global.locoFallbackLanguage}'");
            return struct_get(_fallback_data, _key);
        }
    }
    
    // Key not found in any language
    locoLog($"ERROR: Key '{_key}' not found in any language!", true);
    return global.locoMissingKeyText;
}

/// @function locoSetLanguage(language_code)
/// @description Change the current language
/// @param {string} language_code - The language code to switch to
/// @returns {bool} True if successful, false if language not available
/// @example
/// if (locoSetLanguage("fr")) {
///     show_debug_message("Language changed to French");
/// }
function locoSetLanguage(_language_code) {
    if (global.loco == undefined) {
        locoLog("ERROR: MythLoco not initialized! Call initMythLoco() first.", true);
        return false;
    }
    
    if (!locoLanguageExists(_language_code)) {
        locoLog($"ERROR: Language '{_language_code}' not available!", true);
        return false;
    }
    
    global.lang = _language_code;
    locoLog($"Language changed to: '{_language_code}'");
    return true;
}

/// @function locoLanguageExists(language_code)
/// @description Check if a language is available
/// @param {string} language_code - The language code to check
/// @returns {bool} True if language exists, false otherwise
function locoLanguageExists(_language_code) {
    if (global.loco == undefined) {
        return false;
    }
    
    var _languages = global.loco.languages;
    for (var i = 0; i < array_length(_languages); i++) {
        if (_languages[i] == _language_code) {
            return true;
        }
    }
    return false;
}

/// @function locoGetAvailableLanguages()
/// @description Get array of available language codes
/// @returns {array} Array of language codes or empty array if not initialized
/// @example
/// var langs = locoGetAvailableLanguages();
/// for (var i = 0; i < array_length(langs); i++) {
///     show_debug_message("Available: " + langs[i]);
/// }
function locoGetAvailableLanguages() {
    if (global.loco == undefined) {
        locoLog("ERROR: MythLoco not initialized! Call initMythLoco() first.", true);
        return [];
    }
    
    return global.loco.languages;
}

/// @function locoGetCurrentLanguage()
/// @description Get the current language code
/// @returns {string} Current language code or empty string if not initialized
function locoGetCurrentLanguage() {
    if (global.loco == undefined) {
        locoLog("ERROR: MythLoco not initialized! Call initMythLoco() first.", true);
        return "";
    }
    
    return global.lang;
}

/// @function locoGetKeyCount([language])
/// @description Get the number of keys available in a language
/// @param {string} [language] - Language to count keys for (uses current if not specified)
/// @returns {real} Number of keys available
function locoGetKeyCount(_language = global.lang) {
    if (global.loco == undefined) {
        return 0;
    }
    
    var _translations = global.loco.translations;
    var _lang_data = struct_get(_translations, _language);
    
    if (_lang_data == undefined) {
        return 0;
    }
    
    return struct_names_count(_lang_data);
}

/// @function locoIsInitialized()
/// @description Check if MythLoco system is initialized
/// @returns {bool} True if initialized, false otherwise
function locoIsInitialized() {
    return (global.loco != undefined);
}

// ================================================================================
// USAGE EXAMPLES:
// ================================================================================
//
// // 1. Initialize the system (call once at game start)
// initMythLoco("localization/game_text.mythloco");
//
// // 2. Get localized text
// var title = locoGet("game_title");
// var health = locoGet("ui_health");
//
// // 3. Change language
// locoSetLanguage("fr");
//
// // 4. Check available languages
// var languages = locoGetAvailableLanguages();
//
// // 5. Get text in specific language
// var english_text = locoGet("welcome", "en");
//
// ================================================================================
