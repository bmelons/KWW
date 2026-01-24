extends Weapon
class_name HitscanWeapon

@export var Damage :float = 2.0
@export var FireRate :float = 0.5
@export var Automatic = true
@export var occupiesBothArms : bool = false
@export var Camera :Camera3D
@export var HitscanRay : RayCast3D
@export var Laser : PackedScene
@export var hand: Texture2D
@export var iconFrame : int
var fireDebounce = false
var triggerDown = false
var lastFire := 0.01 : set = set_lastFire
	
var beamorigin = Main.player.bulletpoint
#var rh : Sprite2D
#var icon : Sprite2D

func set_lastFire(n):
	lastFire = n
	Main.cooldownStorage[name] = n

func hitscan_exceptions():
	var exclusions = [Main.player]
	HitscanRay.add_exception(Main.player)
	return exclusions
	

func _ready():
	hitscan_exceptions()
	if Main.cooldownStorage.has(name):
		lastFire = Main.cooldownStorage[name]
	Camera = Main.player.cam
	Main.player.rh.texture = hand
	Main.player.lh.texture = Main.player.get_hand_texture()
	Main.player.icon.frame = iconFrame
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		$trigger.play()
	if Input.is_action_pressed("fire"):
		triggerDown = true
	else:
		triggerDown = false
		fireDebounce = false
	
	if triggerDown and not fireDebounce and (Main.tick()-lastFire) > FireRate:
		if not Automatic:
			fireDebounce = true
		Fire()
		lastFire = Main.tick()
		
		
func _add_fire():
	pass

func Fire():
	_add_fire()
	$gunshot.play()
	var FireDirection = Camera.global_transform
	if not HitscanRay.is_colliding():
		var boom : Beam = Laser.instantiate()
		get_tree().root.add_child(boom)
		var ugh = FireDirection * Transform3D(Basis.IDENTITY,Vector3(0,0,-100))
		boom.Set(beamorigin.global_position, ugh.origin)
		return
	var hit_point = HitscanRay.get_collision_point()
	var boom : Beam = Laser.instantiate()
	#boom.scale.z = (hit_point-global_position).length()
	get_tree().root.add_child(boom)
	print(beamorigin.name)
	boom.Set(beamorigin.global_position,hit_point)
	var hit := HitscanRay.get_collider()
	if hit.has_method("_impact"):
		hit._impact(2)
		
	
