// ================================================================================
// MythLoco Setup
// Example code:
// initMythLoco( _file path_ , _default language (optional- defaults to 'en'_ );
// The example code below assumes you have a "lang" directory in your included files.
// Your "lang" directory (or custom defined directory) should contain your .mythloco file.
//
// ================================================================================

initMythLoco("lang/Demo.mythloco","en");

// ================================================================================
// Example usage:
//   Create a struct to store your translations (or use variables if you prefer)
//   Stored references will need to be redefined if you change language.
//   Here we define a function to make refreshing labels easier
// ================================================================================

function getMenuLabels() {
	return {
			newGame		: locoGet("ui.menus.new_game"),
			loadGame	: locoGet("ui.menus.load_game"),
			settings	: locoGet("ui.menus.settings"),
			quit		: locoGet("ui.menus.quit")
		}
}

menuLabels = getMenuLabels();


// ================================================================================
// Try editing the .mythloco file for free at mythloco.co.uk
// ================================================================================