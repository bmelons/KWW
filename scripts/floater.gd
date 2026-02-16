extends Sprite2D

@export var speed : float = 1
@export var y_magnitude = 20;
@export var y_shift = 0
@onready var start = Main.tick();
@onready var init_pos = self.global_position;

func tick():
	return Main.tick()-start

func _process(delta: float) -> void:
	global_position.y = init_pos.y + sin(tick()*speed*PI) * y_magnitude + y_shift
	
