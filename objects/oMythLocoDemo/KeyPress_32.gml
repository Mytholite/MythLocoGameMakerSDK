// ================================================================================
// Easily switch languges using locoSetLanguage()
// This demo project only has "en" and "fr" defined.
// ================================================================================

var _current = locoGetCurrentLanguage(); // Get the current language code ("en", "fr", etc)
var _lang = (_current == "en" ? "fr" : "en"); // Toggle between "en" and "fr"

// Set the new language
locoSetLanguage(_lang);
// Make sure you refresh your stored translations!
menuLabels = getMenuLabels();