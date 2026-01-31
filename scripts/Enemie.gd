extends CharacterBody3D
class_name Enemy

@export var hp : float = 6 : set = _set_hp
var explosion = preload("res://prefabs/explosion.tscn")
var isAsleep : bool = true : set = _set_isAsleep

signal onAwake

# jan 26 2026 7pm 
# so fucking sad right now so im leaving this permanent mark on my git repo
# i wish they had loved me like i love them


func _step(delta): ## process abastraction
	pass
	
func _process(delta: float) -> void:
	if line_of_sight() and isAsleep == true:
		wake()
	_step(delta)

func wake():
	isAsleep = false



func vector_to_player() -> Vector3: ## returns a vector that represents the distance and direction the player is to the enemy
	return Main.player.global_position-global_position
	
func distance_to_player() -> float : ## returns enemy distance to player
	return (Main.player.global_position-global_position).length()

func line_of_sight() -> bool: ## can the enemy SEEEE the player
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position,Main.player.global_position)
	query.exclude = [self]
	var result = space.intersect_ray(query)
	if result != {}:
		var coll : CollisionObject3D = result.collider
		#print(coll.get_rid(), Main.player.get_rid(),coll.get_rid() == Main.player.get_rid())
		if coll == Main.player:
			return true
	return false

func _set_hp(to):
	var old_hp = hp
	hp = to
	if to-old_hp < 0 and has_node("AudioStreamPlayer3D"):
		$AudioStreamPlayer3D.play(0)
	if to <= 0:
		die()
func die():
	var beeb = explosion.instantiate()
	get_tree().root.add_child(beeb)
	beeb.sc = Vector3.ONE*3
	beeb.global_position = global_position
	queue_free()

func _impact(damage:float):
	hp -= damage;


func _set_isAsleep(to):
	isAsleep = to
	if not to:
		onAwake.emit()
