extends HitscanWeapon


@export var altHand:Texture2D
@export var maxSpreadAngle:float = 15
@export var damp : float = 1.5
@export var MAX_KNOCKS = 3
var current_knocks = 0 : set = set_knocks
var exclusions =[]
func set_knocks(n) -> void:
	current_knocks = n
	Main.cooldownStorage[name+"KNOX"] = n

func _ready():
	exclusions = hitscan_exceptions()
	if Main.cooldownStorage.has(name):
		lastFire = Main.cooldownStorage[name]
	if Main.cooldownStorage.has(name+"KNOX"):
		print(Main.cooldownStorage[name+"KNOX"])
		current_knocks = Main.cooldownStorage[name+"KNOX"]
	Camera = Main.player.cam
	Main.player.rh.texture = hand
	Main.player.lh.texture = altHand
	Main.player.icon.frame = iconFrame

func _process(delta: float) -> void:
	if Main.player.is_on_floor():
		current_knocks = 0
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
		if current_knocks < MAX_KNOCKS:
			current_knocks += 1;
			var backVector = Camera.global_basis.z.normalized() * 10
			Main.player.velocity += backVector
			Main.player.yvel += backVector.y*.6
		for i in range(0,10):
			Fire()
		lastFire = Main.tick()
		
		
func angleGenerator() -> Vector2:
	var spread = randf()**1.5 # percentage damped by a factor of 1.5
	var rot = randf_range(0,4*PI)
	var angles = Vector2(cos(rot),sin(rot)) * deg_to_rad(maxSpreadAngle) * spread
	return angles
func Fire():
	var angle = angleGenerator()
	HitscanRay.rotation = Vector3(angle.x,angle.y,0)
	$gunshot.play()
	var FireDirection = HitscanRay.global_transform
	var space_state = get_world_3d().direct_space_state
	var end = HitscanRay.global_transform * Transform3D(Basis.IDENTITY,HitscanRay.target_position)
	var query = PhysicsRayQueryParameters3D.create(HitscanRay.global_position,end.origin)
	query.exclude = exclusions
	
	var result = space_state.intersect_ray(query)
	
	if result == {}:
		var boom : Beam = Laser.instantiate()
		get_tree().root.add_child(boom)
		var dir = (end.origin-HitscanRay.global_position).normalized() * 100
		var location = HitscanRay.global_position + dir
		boom.Set(HitscanRay.global_position,location)
		return
	print(result)
	var col = result.collider
	var point = result.position
	var boom : Beam = Laser.instantiate()
	get_tree().root.add_child(boom)
	if col.has_method("_impact"):
		col._impact(2)
	boom.Set(Main.player.bulletpoint.global_position,point)
		
		
	
	#if not HitscanRay.is_colliding():
		#var boom : Beam = Laser.instantiate()
		#get_tree().root.add_child(boom)
		#var ugh = FireDirection * Transform3D(Basis.IDENTITY,Vector3(0,0,-100))
		#boom.Set(global_position + Vector3(0,-.1,0), ugh.origin)
		#return
	#var hit_point = HitscanRay.get_collision_point()
	#var boom : Beam = Laser.instantiate()
	#get_tree().root.add_child(boom)
	#boom.Set(global_position + Vector3(0,-.05,0),hit_point)
	#var hit := HitscanRay.get_collider()
	#if hit.has_method("_impact"):
		#hit._impact(2)
