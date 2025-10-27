/// @desc Draw the lottie

var _surface = myLottie.Surface();
var _width = surface_get_width(_surface);
var _height = surface_get_height(_surface);

var _originalWidth = myLottie.Width();
var _originalHeight = myLottie.Height();

var _x = x - _width / 2 + _originalWidth / 2;
var _y = y - _height / 2 + _originalHeight / 2;
draw_surface(_surface, _x, _y);
