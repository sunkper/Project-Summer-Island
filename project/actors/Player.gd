extends KinematicBody

enum State {IDLE, MOVING}
var state = State.IDLE setget _set_state

export (NodePath) var camera_path
onready var camera = get_node(camera_path)
onready var flashlight = camera.get_node("Flashlight")
onready var switch_sound = flashlight.get_node("SwitchSound")

onready var se_switch_on = preload("res://assets/audio/se/objects/LightSwitchOn.wav")
onready var se_switch_off = preload("res://assets/audio/se/objects/LightSwitchOff.wav")

export var speed_def_max: = 7.0
export var speed_sprint_max: = 15.0

export var mov_lerp_weight: = 0.1

var move_speed: = 0.0
var is_sprinting: = false

var vel: = Vector3.ZERO
var dir: = Vector3.ZERO

var float_effect: = true
var elpased: = 0.0

export var mouse_def_sensi: = 0.2
export var mouse_zoomin_sensi: = 0.06
var mouse_sensi: = mouse_def_sensi

export var def_fov: = 75.0
export var zoom_fov: = 30.0

var zooming: = false
var zoomin_lerp: = 0.10
var zoomout_lerp: = 0.30

# simple state management
func _set_state(new_state) -> void:
	if new_state == state:
		return
	
	# exit behavior
	match state:
		State.IDLE:
			pass
		State.MOVING:
			pass
	
	state = new_state
	
	# init behavior
	match state:
		State.IDLE:
			pass
		State.MOVING:
			pass

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	dir = Vector3.ZERO
	var cam_xform = camera.get_camera_transform()
	
	var move_vector = _get_move_input()
	
	if move_vector != Vector3.ZERO:
		move_speed = speed_sprint_max if is_sprinting else speed_def_max
		
		dir += cam_xform.basis.z * move_vector.y
		dir += cam_xform.basis.x * move_vector.x
		dir += cam_xform.basis.y * move_vector.z
	
	vel = lerp(vel, dir * move_speed, 0.1)
	if vel.length() > 0.0:
		self.state == State.MOVING
	else:
		self.state == State.IDLE
	
	vel = move_and_slide(vel, Vector3(0, 1, 0), true)
	
	elpased += delta
	if float_effect:
		move_and_collide(Vector3(0, sin(elpased * 2.5) * 0.004, 0))
	
	# crude implementation of zoom-in
	if zooming:
		camera.fov = lerp(camera.fov, zoom_fov, zoomin_lerp)
		mouse_sensi = lerp(mouse_sensi, mouse_zoomin_sensi, zoomin_lerp)
		$UI/Vignette.modulate.a = lerp($UI/Vignette.modulate.a, 1.0, zoomin_lerp)
	else:
		camera.fov = lerp(camera.fov, def_fov, zoomout_lerp)
		mouse_sensi = lerp(mouse_sensi, mouse_def_sensi, zoomout_lerp)
		$UI/Vignette.modulate.a = lerp($UI/Vignette.modulate.a, 0.0, zoomout_lerp)

func _get_move_input():
	var out: = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		out.y = -1
	elif Input.is_action_pressed("move_backward"):
		out.y = 1
	if Input.is_action_pressed("strafe_left"):
		out.x = -1
	elif Input.is_action_pressed("strafe_right"):
		out.x = 1
	
	if Input.is_action_pressed("ascend"):
		out.z = 1
	elif Input.is_action_pressed("descend"):
		out.z = -1
	
	return out

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotate_x(deg2rad(event.relative.y * mouse_sensi * -1))
		rotate_y(deg2rad(event.relative.x * mouse_sensi * -1))
		
		var camera_rot = camera.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		camera.rotation_degrees = camera_rot
	
	if event.is_action_pressed("sprint"):
		is_sprinting = true
	elif event.is_action_released("sprint"):
		is_sprinting = false
	
	if event.is_action_pressed("flashlight"):
		flashlight.visible = !flashlight.visible
		if flashlight.visible:
			switch_sound.stream = se_switch_on
		else:
			switch_sound.stream = se_switch_off
		switch_sound.play()
	
	if event.is_action_pressed("capture_mouse"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("zoom_view"):
		zooming = true
	elif event.is_action_released("zoom_view"):
		zooming = false
	
	if event.is_action_pressed("noclip"):
		$BodyCollision.disabled = !$BodyCollision.disabled
