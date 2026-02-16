extends Node2D

@export var speed : float = 1
@export var maxDistance : float = 1920
@onready var start = Main.tick();
@onready var init_pos = self.global_position;

var addedPos : Vector2 = Vector2(0,0)

func tick():
	return Main.tick()-start

func _process(delta: float) -> void:
	global_position = addedPos + init_pos
	
	addedPos += Vector2(0,speed*delta)
	if addedPos.length() > maxDistance:
		addedPos = Vector2.ZERO
	
