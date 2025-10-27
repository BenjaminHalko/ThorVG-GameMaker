/// @param	{real} result
/// @param	{string} reason
function __tvg_check(_result, _reason) {
	if (_result != 0) {
		show_error($"ThorVG error {_result}: {_reason}", true);
	}
}

/// @param	{string} data
function TvgSprite(_data) constructor {
	__tvgData = buffer_create(40, buffer_fixed, 1);
	__tvgDataAddress = buffer_get_address(__tvgData);
	
	// Create
	__tvg_check(
		__tvg_create(__tvgDataAddress, _data, string_length(_data)),
	    "Failed to create canvas");
	
	
	__width = buffer_read(__tvgData, buffer_u32);
	__height = buffer_read(__tvgData, buffer_u32);
	__duration = buffer_read(__tvgData, buffer_u32);
	__totalFrames = buffer_read(__tvgData, buffer_u32);
	__framerate = __duration == 0 ? 0 : __totalFrames / __duration;
	__curFrame = 0;

	// Set Target
	__spriteBuffer = buffer_create(__width * __height * 4, buffer_fast, 1);
	__spriteBufferAddress = buffer_get_address(__spriteBuffer);
	__tvg_check(
		__tvg_set_target(__tvgDataAddress, __spriteBufferAddress, __width, __height),
	    "Failed to set target");
	
	// Draw
	__canvasWidth = __width;
	__canvasHeight = __height;
	__isDirty = true;
	__surface = undefined;
	
	static Destroy = function() {
		__tvg_destroy(__tvgDataAddress);
		buffer_delete(__tvgData);
		buffer_delete(__spriteBuffer);
	}
	
	/// @param	{real} xscale
	/// @param	{real} yscale
	static Scale = function(_xscale, _yscale) {
		var _width = round(__width * _xscale);
		var _height = round(__height * _yscale);

		if (__canvasWidth == _width && __canvasHeight == _height)
			return;
		
		__canvasWidth = _width;
		__canvasHeight = _height;
		__isDirty = true;
		
		buffer_resize(__spriteBuffer, _width * _height * 4);
		__spriteBufferAddress = buffer_get_address(__spriteBuffer);
		if (!surface_exists(__surface)) {
			__surface = surface_create(_width, _height);
		} else {
			surface_resize(__surface, _width, _height);
		}
		
		__tvgDataAddress = buffer_get_address(__tvgData);
		__tvg_check(
			__tvg_set_target(__tvgDataAddress, __spriteBufferAddress, _width, _height),
		    "Failed to set target");
	}
	
	/// @return {real}
	static Width = function() {
		return __width;	
	}
	
	/// @return {real}
	static Height = function() {
		return __height;	
	}
	
	/// @return {real}
	static Duration = function() {
		return __totalFrames;	
	}
	
	/// @return {real}
	static TotalFrames = function() {
		return __duration;	
	}
	
	
	/// @return {real}
	static FrameRate = function() {
		return __framerate;
	}
	
	
	/// @param	{real} frame
	static SetFrame = function(_frame) {
		if (__curFrame == _frame || __totalFrames == 0)
			return;

		__tvg_check(
            __tvg_set_frame(__tvgDataAddress, _frame % __totalFrames),
            "Failed to set frames");
		__isDirty = true;
		__curFrame = _frame;
	}
	
	/// @return {Id.Surface}
	static Surface = function() {
		if (!surface_exists(__surface)) {
			__surface = surface_create(__canvasWidth, __canvasHeight);
			__isDirty = true;
		}
		
		if (__isDirty) {
			__isDirty = false;
			
			__tvg_check(
                __tvg_draw(__tvgDataAddress, true),
                "Failed to draw to canvas");
            
			buffer_set_surface(__spriteBuffer, __surface, 0);
		}
		
		return __surface;
	}
}

/// @param	{string} filePath
/// @return {struct.TvgSprite}
function TvgSpriteFromFile(_filePath) {
	var _file = file_text_open_read(_filePath);
	var _lottieString = "";
	while(!file_text_eof(_file)) {
		_lottieString += file_text_readln(_file);
	}
	file_text_close(_file);
	return new TvgSprite(_lottieString);
}
