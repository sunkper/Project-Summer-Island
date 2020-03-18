extends KinematicBody

export var dir: = Vector3(0.0, 0.0, 1.0) setget _changed_dir
export (float, 0.001, 10.0) var speed: = 1.0
export (float, 0.001, 20.0) var length: = 1.0
export (float, 0.001, 10.0) var radius: = 0.5 setget _changed_radius

export var blow: = false setget _start_blow

var orig_pos: = Vector3.ZERO

func _changed_dir(new_dir) -> void:
	if new_dir == dir:
		return
	
	dir = new_dir.normalized()

func _changed_radius(new_radius) -> void:
	if new_radius == radius:
		return
	
	radius = new_radius
	if $CollisionShape.shape != null:
		$CollisionShape.shape.radius = radius

func _start_blow(new_state) -> void:
	if new_state == blow:
		return
	
	blow = new_state
	if blow:
		set_physics_process(true)
		$CollisionShape.disabled = false
	else:
		set_physics_process(false)
		$CollisionShape.disabled = true

func _ready() -> void:
	orig_pos = translation
	var c = SphereShape.new()
	$CollisionShape.shape = c
	$CollisionShape.shape.radius = radius

func _physics_process(delta: float) -> void:
	translation += dir * speed * delta
	
	if orig_pos.distance_to(translation) >= length:
		translation = orig_pos
