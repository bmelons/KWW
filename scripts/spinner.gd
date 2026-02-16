extends Node3D

@export var speed = .01;
@export var axis : Vector3 = Vector3(0,1,0)

func  _process(delta: float) -> void:
	rotate(axis,speed*PI)
