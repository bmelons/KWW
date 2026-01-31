extends Sprite3D

var timer = 0
@onready var sc = self.scale

func _ready() -> void:
	$AudioStreamPlayer3D.pitch_scale = randf_range(.7,1.2)
	$AudioStreamPlayer3D.play(.4)

func _process(delta: float) -> void:
	#scale = Vector3.ONE*4
	if frame >= 15:
		queue_free()
	timer+=1;
	if timer > 6:
		timer = 0
		frame += 1
	if not get_viewport().get_camera_3d():
		return
	
	global_transform = global_transform.looking_at(get_viewport().get_camera_3d().global_position)
	scale = sc
