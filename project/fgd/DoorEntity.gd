class_name DoorEntity
extends KinematicBody

export(Dictionary) var properties setget set_properties

var move_dir := Vector3.UP
var move_dist := 1.0
var audio_path := ""

var audio_node

signal opening_started
signal opening_finshied

func set_properties(new_properties : Dictionary) -> void:
	if(properties != new_properties):
		properties = new_properties
		update_properties()

func update_properties():
	if "direction" in properties:
		move_dir = properties["direction"]

	if "distance" in properties:
		move_dist = properties["distance"]
	
	if "sound" in properties:
		audio_path = properties["sound"]
		audio_node = AudioStreamPlayer3D.new()
		audio_node.stream = load(audio_path)
		add_child(audio_node)

func _ready() -> void:
	update_properties()

func _process(delta: float) -> void:
	pass
