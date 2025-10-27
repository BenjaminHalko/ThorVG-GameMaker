/// @desc Update frames

var _currentSecond = current_time / 1000;
var _frameRate = myLottie.FrameRate();
myLottie.SetFrame(_currentSecond * _frameRate);


// Wave the size
if (pulse) {
	var _scale = (sin(current_time / 1500 * pi + x + y) + 1) / 2 + 0.5;
	myLottie.Scale(_scale, _scale);
}
