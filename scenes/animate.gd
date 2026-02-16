extends Sprite2D

var framePerFrame : int = 0;
var ticker : int = 0
var maxframes :int = 5

func _process(delta: float) -> void:
	if ticker > framePerFrame:
		frame += 1
		frame = frame%maxframes
