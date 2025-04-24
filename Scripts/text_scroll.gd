extends Label

@export var max_chars : int

const TIME_PER_CHAR = 0.75

var scroll_text : String = ""


var _timer : float = 0.75
var _progress : int = 0
func _process(delta: float) -> void:
	if scroll_text.length() > max_chars:
		_timer += delta
		if _timer > TIME_PER_CHAR:
			_timer -= TIME_PER_CHAR
			
			var temp = scroll_text + "   " + scroll_text + "   " + scroll_text
			text = temp.substr(_progress, max_chars)
			_progress += 1
			if _progress > scroll_text.length() + 2:
				_progress = 0
	else:
		text = scroll_text
		_timer = 0.75
		_progress = 0
