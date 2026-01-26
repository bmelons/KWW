extends CharacterBody3D
class_name Enemy

@export var hp :float = 6 : set = _set_hp
var explosion = preload("res://prefabs/explosion.tscn")

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
		if coll == Main.player:
			return true
	return false

func _set_hp(to):
	var old_hp = hp
	hp = to
	if to-old_hp < 0:
		$AudioStreamPlayer3D.play(0)
	if to <= 0:
		die()
func die():
	var beeb = explosion.instantiate()
	get_tree().root.add_child(beeb)
	beeb.global_position = global_position
	queue_free()

func _impact(damage:float):
	hp -= damage;
	
