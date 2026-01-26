extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Label.text = Main.msg
	$Button.pressed.connect(passage)
	
func passage():
	get_tree().change_scene_to_packed(Main.nextScene)
