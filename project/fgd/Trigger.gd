# This is basic and specific implementation for a little secret.

class_name Trigger
extends Area

const SECRET_CODE = [4, 5, 1]
var pressed_codes := []

export(Dictionary) var properties setget set_properties

var target := ""
var targetname := ""

var monitorting_interaction := false

var audio_node

signal triggered()
signal interacted()

onready var se_beep = preload("res://assets/audio/se/objects/BeepShort.wav")
onready var se_no = preload("res://assets/audio/se/objects/No.wav")

func set_properties(new_properties : Dictionary) -> void:
	if(properties != new_properties):
		properties = new_properties
		update_properties()

func update_properties() -> void:
	if "target" in properties:
		target = properties["target"]

func _ready() -> void:
	update_properties()
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	
	audio_node = AudioStreamPlayer3D.new()
	audio_node.stream = se_beep
	add_child(audio_node)

func _on_area_entered(area) -> void:
	if "player" in area.get_parent().get_groups():
		monitorting_interaction = true

func _on_area_exited(area) -> void:
	if "player" in area.get_parent().get_groups() and monitorting_interaction:
		if pressed_codes.size() > 0:
			_reset_code()
		monitorting_interaction = false

func _input(event: InputEvent) -> void:
	if monitorting_interaction:
		if event is InputEventKey and event.pressed:
			if (KEY_0 <= event.scancode and event.scancode <= KEY_9) or (KEY_KP_0 <= event.scancode and event.scancode <= KEY_KP_9):
				pressed_codes.append(int(event.as_text()))
				audio_node.play()
				print(pressed_codes)
				yield(audio_node, "finished")
				if pressed_codes.size() == 3:
					_check_if_this_game_is_immersive_sim()
				if pressed_codes.size() > 3:
					_reset_code()

func _check_if_this_game_is_immersive_sim() -> void:
	if pressed_codes == SECRET_CODE:
		set_monitorable(false)
		trigger()
	else:
		_reset_code()

func _reset_code():
	audio_node.stream = se_no
	audio_node.play()
	yield(audio_node, "finished")
	pressed_codes.clear()
	audio_node.stream = se_beep

func trigger() -> void:
	get_tree().call_group(target, "trigger")
	queue_free()
