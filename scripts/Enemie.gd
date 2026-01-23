extends CharacterBody3D
class_name Enemy

@export var hp :float = 6 : set = _set_hp
var explosion = preload("res://prefabs/explosion.tscn")
#var yvelB
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
	
