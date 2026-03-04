extends Area3D

@export var Hinge : Node3D
@export var OpenNoise : AudioStreamPlayer3D
@export var OPEN_TIME : float = .3
@export var POSITION_OFFSET : Vector3 = Vector3(-PI/2,0,0)
#@export var UnlockSignal
@export var Locked = false

func _ready() -> void:
	body_entered.connect(_body_entered);
	
func _body_entered(bod :Node3D):
	if bod == Main.player:
		open()

func open():
	if Locked:
		return
	Locked=true
	print("OPEN")
	var t = get_tree().create_tween()
	t.set_parallel(true)
	t.tween_property(Hinge,'position',Hinge.rotation+POSITION_OFFSET,OPEN_TIME)
	t.play()
