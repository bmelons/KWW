extends Enemy
@export var WALK_SPEED :float = 2
const  PROJECTILE_SPEED = 20
var yvel = 0
var GRAVITY : float = 9.0
var MAX_FALL_SPEED = 500.0

var last_fire = 0
const BULLET = preload("res://prefabs/bullet.tscn")

func _process(delta: float) -> void:
	yvel = max(yvel-GRAVITY*delta,-MAX_FALL_SPEED)
	if is_on_floor():
		yvel = 0
	velocity =  ai_move_direction()
	velocity.y = yvel
	ai_action()
	move_and_slide()
	
func vector_to_player() -> Vector3: ## returns a vector that represents the distance and direction the player is to the enemy
	return Main.player.global_position-global_position
	
func distance_to_player() -> float : ## returns enemy distance to player
	return (Main.player.global_position-global_position).length()


func calculate_trajectory():
	var pos = Main.player.position
	var vel = Main.player.get_real_velocity()
	var dist = ((pos+vel)-global_position).length()
	var time_to_reach = dist/PROJECTILE_SPEED
	for i in range(1,5):
		dist = ((pos+(vel*time_to_reach))-global_position).length()
		time_to_reach = dist/PROJECTILE_SPEED
	return global_transform.looking_at( (pos+(vel*time_to_reach)) )
	
		

func ai_action():
	$looker.global_transform = global_transform.looking_at(Main.player.global_position)
	if (Main.tick()-last_fire) > .6:
		last_fire = Main.tick()
		var shoot = BULLET.instantiate()
		get_tree().root.add_child(shoot)
		shoot.global_transform = calculate_trajectory()

func ai_move_direction() -> Vector3:
	#print(distance_to_player())
	if distance_to_player() >= 10:
		return (vector_to_player()*Vector3(1,0,1)).normalized() * WALK_SPEED * 1.5
	elif distance_to_player() < 3:
		return -(vector_to_player()*Vector3(1,0,1)).normalized() * WALK_SPEED
	else:
		return (vector_to_player()*Vector3(1,0,1)).normalized() * WALK_SPEED
		
