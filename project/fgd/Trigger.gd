# This is basic and specific implementation for a little secret.

class_name Trigger
extends Node

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
	connect("area_enterted", self, "_on_area_entered")
	
	audio_node = AudioStreamPlayer3D.new()
	audio_node.stream = se_beep
	add_child(audio_node)

func _on_area_entered(area) -> void:
	print("an area entered")
	if "player" in area.get_parent().get_groups():
		print("it's player's detector entered, begin monitoring")
		monitorting_interaction = true

func _on_area_exited(area) -> void:
	print("an area exited")
	if "player" in area.get_parent().get_groups() and monitorting_interaction:
		print("it's player's detector exited, cease monitoring")
		monitorting_interaction = false

func _input(event: InputEvent) -> void:
	if monitorting_interaction:
		if event is InputEventKey and event.pressed:
			print("some key has pressed")
			if (KEY_0 <= event.scancode <= KEY_9) or (KEY_KP_0 <= event.scancode <= KEY_KP_9):
				print("it's a number/numpad key")
				pressed_codes.push_front(int(event.as_text))
				audio_node.play()
				if pressed_codes.size() == 3:
					print("three keys pressed, checking...")
					_check_if_this_game_is_immersive_sim()

func _check_if_this_game_is_immersive_sim() -> void:
	if pressed_codes == SECRET_CODE:
		print("Correct code!")
		trigger()
	else:
		print("NOOOO!!!!!!!")
		audio_node.stream = se_no
		audio_node.play()
		pressed_codes.empty()
		audio_node.stream = se_beep

func trigger() -> void:
	get_tree().call_group(target, "trigger")
