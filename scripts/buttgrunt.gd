extends Enemy

var yvel = 0
var GRAVITY = 9.0
var MAX_FALL_SPEED = 500.0

func _process(delta: float) -> void:
	yvel = max(yvel-GRAVITY*delta,-MAX_FALL_SPEED)
