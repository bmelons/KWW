extends Enemy
class_name Crate

var GRAVITY = 5.0
var yvel = 0

func _step(delta):
	if is_on_floor():
		yvel = 0
	else:
		yvel -= GRAVITY
	velocity.y = yvel
	move_and_slide()
