/// @desc Example code- safe to delete

var _menuString = $"{menuLabels.newGame}\n{menuLabels.loadGame}\n{menuLabels.settings}\n{menuLabels.quit}";

var _x = (display_get_gui_width()/2) , _y = (display_get_gui_height()/2);
draw_set_halign(fa_center); draw_set_valign(fa_middle);
draw_text(_x, _y, _menuString);


draw_set_halign(fa_left);
draw_text(10,10,"Press space to toggle between English and French");