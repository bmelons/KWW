extends Enemy

var yvel : float = 0
@export var WALK_SPEED :float = 3.5
var MAX_FALL_SPEED = 500.0
var GRAVITY : float = 9.0
var internal_vel = Vector3.ZERO

func _process(delta: float) -> void:
	yvel = max(yvel-Main.GRAVITY*delta,-MAX_FALL_SPEED)
	if is_on_floor():
		yvel = 0
	velocity = velocity.slerp(ai_move_direction(),1-.5*delta)
	velocity.y = yvel
	ai_action()
	move_and_slide()

func ai_action():
	pass

func ai_move_direction() -> Vector3:
	#print(distance_to_player())
	if distance_to_player() >= 10:
		return (vector_to_player()*Vector3(1,0,1)).normalized() * WALK_SPEED * 1.5
	elif distance_to_player() < 3:
		return -(vector_to_player()*Vector3(1,0,1)).normalized() * WALK_SPEED
	else:
		return (vector_to_player()*Vector3(1,0,1)).normalized() * WALK_SPEED
