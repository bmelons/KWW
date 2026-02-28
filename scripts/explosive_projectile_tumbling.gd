extends RigidBody3D

const KNOCKBACK := 60.0
var explosion = preload("res://prefabs/explosion.tscn")
@onready var splosionField : ShapeCast3D = $splosionField
@export var fuseTime : float = 3
var radius = 2.3
var debounce = false
@onready var initTimestamp = Main.tick()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	splosionField.add_exception(self)
	self.add_collision_exception_with(Main.player)
	#$bigger_hitbox_for_guns.impact_event.connect(_impact)


#func a = Main.tick
#ignore i thought i would try lua stuff </3 💔

# wadqsdqwwq
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if debounce: return; # makes sure it doesnt explode more than 1 time
	if Main.time_since(initTimestamp) > fuseTime:
		explode()

func explosiondamage():
	#var hit_bodies = splosionField.collide_with_bodies
	for i in range(0,splosionField.get_collision_count()):
		var hit : PhysicsBody3D = splosionField.get_collider(i)
		if hit.has_method("_impact"):
			#print(hit.name)
			if hit.name == "Meowless Sterling":
				hit._impact(40)
			if hit.name.begins_with("nade"):
				hit.explode()
			else:
				hit._impact(4)
		
func explosionKnockback():
	# TODO: figure out how to optimize this stuf and make explosion knockback and damage work through in one loop
	for i in range(0,splosionField.get_collision_count()):
		var hit : PhysicsBody3D = splosionField.get_collider(i)
		var dirTo = (hit.global_position-self.global_position).normalized()
		var property = "velocity"
		
		if "linear_velocity" in hit:
			property = "linear_velocity"
		if not property in hit:
			continue
		hit.set(property, hit.get(property) + dirTo*KNOCKBACK )
		
func explode():
	#check again
	if debounce: return; 
	debounce = true
	## TODO: this code gets used a lot, consolidate it somewhere soon
	var beeb = explosion.instantiate()
	get_tree().root.add_child(beeb)
	beeb.sc = Vector3.ONE*(radius*5)
	beeb.global_position = global_position
	explosiondamage()
	explosionKnockback()
	queue_free()

func _impact(dmg):
	if get_stack().size() > 10: ## TODO: make a better fix for explosion infinity bug
		print("max stack size reached, halting")
		return
	explode()
