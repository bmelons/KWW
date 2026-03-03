extends Weapon

@export var ProjectilePrefab : PackedScene # most damage stuff is handled in this object & not here
@export var ThrowVelocity : float = 30.0
@export var FireRate :float = 2
@export var Automatic = true
@export var occupiesBothArms : bool = false
@export var Camera :Camera3D
@export var HitscanRay : RayCast3D
@export var hand: Texture2D
@export var iconFrame : int

var fireDebounce = false
var triggerDown = false
var lastFire := 0.01 : set = set_lastFire


func set_lastFire(n):
	lastFire = n
	Main.cooldownStorage[name] = n
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Main.cooldownStorage.has(name):
		lastFire = Main.cooldownStorage[name]
	Camera = Main.player.cam
	Main.player.rh.texture = hand
	Main.player.lh.texture = Main.player.get_hand_texture()
	Main.player.icon.frame = iconFrame

func can_fire() -> bool:
	return triggerDown and not fireDebounce and (Main.tick()-lastFire) > FireRate

func _add_fire():
	pass

func Fire():
	_add_fire()
	$gunshot.play()
	var FireDirection = Camera.global_transform
	var projectile : RigidBody3D = ProjectilePrefab.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = Main.player.cam.global_position 
	projectile.angular_velocity = Vector3(randfn(20,20),randfn(20,5),randfn(20,5))
	projectile.linear_velocity = -FireDirection.basis.z * ThrowVelocity + Main.player.get_real_velocity() #+ Vector3(0,4,0)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		$trigger.play()
	if Input.is_action_pressed("fire"):
		triggerDown = true
	else:
		triggerDown = false
		fireDebounce = false
	
	if can_fire():
		if not Automatic:
			fireDebounce = true
		Fire()
		lastFire = Main.tick()
