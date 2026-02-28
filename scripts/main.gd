extends Node
## singleton called Main

func _process(delta: float) -> void:
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func tick():
	return float(Time.get_ticks_msec())/1000

func time_since(timestamp):
	return tick()-timestamp

var player : Player
var cooldownStorage : Dictionary[String,float] = {}
var GRAVITY :float = 9.0
var msg : String = ""
var nextScene : PackedScene
var PERSIST_GUNS : Array[PackedScene]
var pause : get = is_pause
var pauseMenu = false
var pausedUntilWhen = 0;

func is_pause():
	if pauseMenu:
		return true

func hitstop(howLongSecs : float) -> void:
	return
	
