# One-shot door only implemented for a little secret
class_name DoorEntity
extends KinematicBody

export(Dictionary) var properties setget set_properties

var move_dir := Vector3.UP
var move_dist := 1.0
var move_speed := 1.0
var audio_path := ""

var dist_to_go : float
var goal_translation : Vector3
var audio_node

var triggered := false

signal move_started()
signal move_finshied()

func set_properties(new_properties : Dictionary) -> void:
	if(properties != new_properties):
		properties = new_properties
		update_properties()

func update_properties() -> void:
	if "direction" in properties:
		move_dir = properties["direction"]

	if "distance" in properties:
		move_dist = properties["distance"]
	
	if "sound" in properties:
		audio_path = properties["sound"]
		audio_node = AudioStreamPlayer3D.new()
		audio_node.stream = load(audio_path)
		add_child(audio_node)
	
	if "speed" in properties:
		move_speed = properties["speed"]
	
	if "targetname" in properties:
		add_to_group(properties["targetname"])

func _ready() -> void:
	set_physics_process(false)
	update_properties()
	

func _physics_process(delta: float) -> void:
	var _delta = delta
	if dist_to_go <= 0.0:
		set_physics_process(false)
		emit_signal("move_finished")
		return
	elif dist_to_go < delta:
		_delta = dist_to_go
	
	translate_object_local(move_dir * move_speed * _delta)
	dist_to_go -= delta

func trigger() -> void:
	print("Door triggered")
	open()

func open() -> void:
	if triggered:
		return
	
	triggered = true
	dist_to_go = move_dist
	goal_translation = translation + (move_dir * move_dist)
	if audio_node:
		audio_node.play()
	emit_signal("move_started")
	set_physics_process(true)
