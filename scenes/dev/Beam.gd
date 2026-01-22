extends Node3D
class_name Beam
var initial := 0.0
func Set(from:Vector3,to:Vector3):
	var location = (from+to)/2
	var length = (to-from).length()
	var bas = Basis.looking_at(to-from,Vector3(0,1,0))
	global_transform = Transform3D(bas,location)
	$MeshInstance3D.scale.y = length
	
func _ready() -> void:
	initial = Main.tick()

func _process(delta: float) -> void:
	var mat : Material = $MeshInstance3D.get_surface_override_material(0)
	var t = (Main.tick()-initial)*8
	if t>1:
		queue_free()
	mat['albedo_color'] = Color(1,.91,.37,1- clampf(t,0.0,1.0))
	$MeshInstance3D.scale.x = 1- clampf(t,0.0,1.0)
	$MeshInstance3D.scale.z = 1- clampf(t,0.0,1.0)
	
