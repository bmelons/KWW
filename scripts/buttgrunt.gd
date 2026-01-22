extends Enemy

var yvel = 0

func _process(delta: float) -> void:
	yvel = max(yvel-GRAVITY*delta,-MAX_FALL_SPEED)
