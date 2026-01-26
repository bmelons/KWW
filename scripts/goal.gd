extends Area3D
class_name Goal

@export var whereTo : PackedScene

func _process(delta: float) -> void:
	for i in get_overlapping_bodies():
		if i == Main.player:
			nextlevel()
func nextlevel():
	Main.nextScene = whereTo
	Main.msg = "UR A \n WEINER!"
	get_tree().change_scene_to_file("res://scenes/loss.tscn")
