extends KinematicBody

export var speed_def_max: = 7.0
export var speed_sprint_max = 15.0

const GRAVITY = 10.0

var move_speed: = 0.0
var is_sprinting: = false
var is_flying: = true

var vel: = Vector3.ZERO

var dir: = Vector3.ZERO

export var mouse_def_sensi: = 0.2
export var mouse_zoomin_sensi: = 0.03
var mouse_sensi: = mouse_def_sensi

export var def_fov: = 75.0
export var zoom_fov: = 30.0

var zooming: = false
var zoomin_lerp: = 0.05
var zoomout_lerp: = 0.15


func _ready() -> void:
	$EditorHint.hide()

func _physics_process(delta: float) -> void:
	dir = Vector3.ZERO
	var cam_xform = $Camera.get_camera_transform()
	
	var move_vector = _get_move_input()
	
	if move_vector != Vector3.ZERO:
		move_speed = speed_sprint_max if is_sprinting else speed_def_max
		
		dir += cam_xform.basis.z * move_vector.y
		dir += cam_xform.basis.x * move_vector.x
		dir += cam_xform.basis.y * move_vector.z
	
	vel = dir * move_speed
	
	if not is_flying:
		vel.y -= GRAVITY
	
	vel = move_and_slide(vel, Vector3(0, 1, 0), true)

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
	if is_flying:
		if Input.is_action_pressed("ascend"):
			out.z = 1
		elif Input.is_action_pressed("descend"):
			out.z = -1
	
	return out

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$Camera.rotate_x(deg2rad(event.relative.y * mouse_sensi * -1))
		rotate_y(deg2rad(event.relative.x * mouse_sensi * -1))
		
		var camera_rot = $Camera.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		$Camera.rotation_degrees = camera_rot
	
	if event.is_action_pressed("sprint"):
		is_sprinting = true
	elif event.is_action_released("sprint"):
		is_sprinting = false
