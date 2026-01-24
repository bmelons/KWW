extends MeshInstance3D
class_name ProjectileBase

@export var MOVE_SPEED :float = 20.0
@export var DAMAGE : float = 12.0
var explosion = preload("res://prefabs/explosion.tscn")
func _process(delta: float) -> void:
	var move_dir = -basis.z * delta* MOVE_SPEED
	
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.create(global_position,global_position + move_dir)
	var query = space_state.intersect_ray(params)
	global_position += move_dir
	if query != {}:
		var coll : CollisionObject3D = query.collider
		print("i hit something...")
		if coll is Enemy:
			print("UHM?")
			#_process(delta)
			return
		if coll.has_method("_impact"):
			coll._impact(DAMAGE)
			print("something BAD")
		die()
	
	
	
func die():
	var beeb = explosion.instantiate()
	get_tree().root.add_child(beeb)
	beeb.global_position = global_position
	queue_free()
