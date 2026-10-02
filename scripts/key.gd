extends Area3D
class_name Key

@export var associatedDoor : DoorGeneric

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(area :Node3D):
	associatedDoor.Locked = false
	Main.player.spawn_hint("I think the key have an open the door's locks")
	queue_free()
	
