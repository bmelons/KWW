extends Node3D

signal impact_event(dmg)

func _impact(dmg):
	impact_event.emit(dmg);
