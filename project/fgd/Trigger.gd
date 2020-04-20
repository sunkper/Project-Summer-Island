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
var keypad_ui

signal triggered()
signal interacted()

var se_beep = preload("res://assets/audio/se/objects/BeepShort.wav")
var se_no = preload("res://assets/audio/se/objects/No.wav")


func set_properties(new_properties : Dictionary) -> void:
	if(properties != new_properties):
		properties = new_properties
		update_properties()

func update_properties() -> void:
	if "target" in properties:
		target = properties["target"]

func trigger() -> void:
	get_tree().call_group(target, "trigger")
	queue_free()

func _ready() -> void:
	update_properties()
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")
	
	audio_node = AudioStreamPlayer3D.new()
	audio_node.stream = se_beep
	add_child(audio_node)
	
	keypad_ui = Label.new()
	keypad_ui.add_font_override("font", load("res://assets/fonts/UIKeypadFont.tres"))
	keypad_ui.set_anchors_and_margins_preset(Control.PRESET_BOTTOM_RIGHT)
	keypad_ui.margin_left = -256.0
	keypad_ui.margin_top = -192.0
	keypad_ui.hide()
	add_child(keypad_ui)

func _on_area_entered(area) -> void:
	if "player" in area.get_parent().get_groups():
		monitorting_interaction = true
		keypad_ui.show()

func _on_area_exited(area) -> void:
	if "player" in area.get_parent().get_groups() and monitorting_interaction:
		keypad_ui.hide()
		if pressed_codes.size() > 0:
			_reset_code()
		monitorting_interaction = false

func _input(event: InputEvent) -> void:
	if monitorting_interaction:
		if event is InputEventKey and event.pressed:
			if (KEY_0 <= event.scancode and event.scancode <= KEY_9) or (KEY_KP_0 <= event.scancode and event.scancode <= KEY_KP_9):
				pressed_codes.append(int(event.as_text()))
				audio_node.play()
				if pressed_codes.size() >= 3:
					pressed_codes.resize(3)
				var text : String
				for n in pressed_codes:
					text += str(n)
				keypad_ui.text = text
				yield(audio_node, "finished")
				if pressed_codes.size() == 3:
					monitorting_interaction = false
					_check_if_this_game_is_immersive_sim()

func _check_if_this_game_is_immersive_sim() -> void:
	if pressed_codes == SECRET_CODE:
		trigger()
	else:
		_reset_code()
		monitorting_interaction = true

func _reset_code():
	audio_node.stream = se_no
	audio_node.play()
	yield(audio_node, "finished")
	pressed_codes.clear()
	keypad_ui.text = ""
	audio_node.stream = se_beep
