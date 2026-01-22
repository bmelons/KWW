extends CharacterBody3D
class_name Player
enum states {GROUNDED, FALLING, IDLE}

@export var GUNS : Array[PackedScene]


@export var MOUSE_SENS := .2
@export var JUMP_COOLDOWN := .1
@export var AIR_SPEED := 32.0
@export var WALK_SPEED := 16
@export var STOP_SPEED := 10.0
@export var GRAVITY := 80.0
@export var MAX_FALL_SPEED := 500.0
@export var ACCELERATE := 10.0
@export var AIR_ACCELERATE := 0.7
@export var MOVE_FRICTION := 6.0
@export var JUMP_FORCE := 27.0
@export var AIR_CONTROL = 0.9
@export var STEP_SIZE := 1.8
@export var MAX_HANG := 0.2
@export var PLAYER_HEIGHT = 3.6
@export var CROUCH_HEIGHT := 2.0
@export var STRIDE := 150
@export var STRIDE_SPEED := 3
@export var is_dead = false

@export var STANDING_SHAPE : CapsuleShape3D
@export var CROUCHING_SHAPE : CapsuleShape3D

@export var Hands : Node2D

var currentGun : int : set = set_current_gun
var gunObject : Weapon
var graph = Vector3(1,0,1)
var rocktick = 0
var yvel = 0
var lastJumpInput = 0
var lastRealJump = 0
var airtime = 0
var wallJumps = 0
var lust = 0

@onready var cam = $Camera3D;
@onready var collider := $CollisionShape3D
@onready var climbRay := $Camera3D/ClimbRay
@export var slashMaterial : Material
@onready var icon = $Camera3D/Node2D/Icon
@onready var rh = $Camera3D/hands/RightHand
@onready var lh = $Camera3D/hands/LeftHand
@onready var ah = $Camera3D/hands/AltHand
@onready var bulletpoint = $Camera3D/bulletPoint
@onready var bulletpoint2 = $Camera3D/bulletPoint2

func _ready() -> void:
	Main.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	slashMaterial["albedo_color"] = Color(1,1,1,0)
	await get_tree().create_timer(.1).timeout
	currentGun = 0
	
	pass

func get_hand_texture():
	return load("uid://dn83aofwibgea")

func set_current_gun(to:int):
	print("set")
	currentGun = to
	if gunObject:
		gunObject.queue_free()
	var a = GUNS[to].instantiate()
	cam.add_child(a)
	gunObject = a

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rel = event.relative * PI/180 * MOUSE_SENS
		cam.rotation.x += -rel.y
		rotation.y += -rel.x
		cam.rotation.x = clampf( cam.rotation.x, deg_to_rad(-89), deg_to_rad(89) )
		
#func exit_check()

func rockabilly():
	if velocity.length() < 1 or not is_on_floor():
		rocktick = Main.tick()
		Hands.position = Hands.position.lerp(Vector2(0,STRIDE/2),0.5)
		return
	var t = fmod(Main.tick()-rocktick,4)*PI*STRIDE_SPEED 
	var rockx = STRIDE*sin((t)/2)
	var rocky = STRIDE*((sin(t)+1)/2)+ STRIDE/2
	Hands.position = Vector2(rockx,rocky)

func ground_check():
	print(global_position)
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position,Vector3(0,-2.01,0),1,[self.get_rid()])
	query.hit_from_inside = false
	var ray =space_state.intersect_ray(query)
	if ray == {} or ray == null:
		return false
	
	return true
		
func get_look_vector():
	return -cam.basis.z

func slash_visual():
	#Material.
	pass

func scroll():
	if Input.is_action_just_pressed("gun_next"):
		print("neext")
		currentGun = (currentGun + 1) % GUNS.size()
	elif Input.is_action_just_pressed("gun_prev"):
		if currentGun < 1:
			currentGun = GUNS.size()-1
		else:
			currentGun -=1
	if Input.is_action_just_pressed("slot0") and currentGun!=0:
		currentGun = 0
	if Input.is_action_just_pressed("slot1") and currentGun!=1:
		currentGun = 1
	if Input.is_action_just_pressed("slot2") and currentGun!=2:
		currentGun = 2

func get_move_direction():
	return Vector3(Input.get_axis("move_left","move_right"),
	0,
	Input.get_axis("move_fwd","move_back")).normalized().rotated(Vector3.UP,rotation.y)

func jumpstuff(move_direction:Vector3,delta):
	if Input.is_action_just_pressed("jump"):
			lastJumpInput = Main.tick()
	if is_on_floor() and Main.tick()-lastRealJump > JUMP_COOLDOWN:
		
		wallJumps = 0
		yvel = 0
		lastRealJump = Main.tick()
		if Main.tick()-lastJumpInput < .1:
			print("JAMP")
			lastJumpInput = 0
			yvel += JUMP_FORCE
			if move_direction.length() < .1:
				velocity = velocity
			else:
				velocity = move_direction.normalized() * AIR_SPEED
	else:
		yvel = max(yvel-GRAVITY*delta,-MAX_FALL_SPEED)
func slash_do():
	var old = lh.texture
	var tx = load("res://hands/hands9.png")
	lh.texture = tx
	$Camera3D/Slash.scale = Vector3(1.7,2,1)
	var look = -cam.global_basis.z
	velocity = look * max(velocity.length(),16)
	yvel = velocity.y * 0.3
	slashMaterial["albedo_color"] = Color(1,1,1,1)
	var tw = get_tree().create_tween()
	tw.tween_property($Camera3D/Slash,"scale",Vector3(1,1,2),.2)
	tw.play()
	await get_tree().create_timer(.2).timeout
	lh.texture = old


func _process(delta: float) -> void:
	if is_dead:
		get_tree().reload_current_scene()
	var move_direction = get_move_direction()* WALK_SPEED
	scroll()
	jumpstuff(move_direction,delta)
	var crouch = Input.is_action_pressed("crouch")
	
	if Input.is_action_just_pressed("crouch"):
		collider.shape = CROUCHING_SHAPE
		global_position.y -= (STANDING_SHAPE.height-CROUCHING_SHAPE.height)/2
	elif Input.is_action_just_released("crouch"):
		collider.shape = STANDING_SHAPE
		global_position.y += (STANDING_SHAPE.height-CROUCHING_SHAPE.height)/2
	
	if Input.is_action_just_pressed("scratch") and not gunObject.occupiesBothArms:
		slash_do()
	slashMaterial["albedo_color"] = slashMaterial["albedo_color"].lerp(Color(1,1,1,0),.1) 
	
	if is_on_floor():
		if crouch:
			velocity = velocity * (1- .3*delta)
		elif Main.tick()-airtime>.1:
			if move_direction.length() < .5:
				velocity = velocity.move_toward(move_direction,.5)
			else:
				velocity = velocity.move_toward(move_direction,.8)
		else:
			velocity = velocity.move_toward(move_direction,.8)
	else:
		airtime = Main.tick()
		if move_direction.length() < .1:
			velocity = velocity
		else:
			velocity = velocity.move_toward(move_direction,.8 * AIR_CONTROL)
			velocity = velocity.normalized() * AIR_SPEED
	velocity.y = yvel
	if is_on_wall():
		velocity *= .8
	move_and_slide()
	rockabilly()
