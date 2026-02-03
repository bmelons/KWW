extends Node


func _process(delta: float) -> void:
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func tick():
	return float(Time.get_ticks_msec())/1000

var player : Player
var cooldownStorage : Dictionary[String,float] = {}
var GRAVITY :float = 9.0
var msg : String = ""
var nextScene : PackedScene
var PERSIST_GUNS : Array[PackedScene]
