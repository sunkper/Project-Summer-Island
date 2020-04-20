extends Control

onready var tween = $Tween

onready var logo = $Logo

onready var time_of_day = $TimeOfDay
onready var time_menu = $TimeOfDay/ChooseTime
onready var time_image = $TimeOfDay/TimeImage

onready var settings = $SettingPanels
onready var light_hall = $SettingPanels/PnaelLightsBox/PanelLights/VBoxContainer/ButtonHall
onready var light_kitchen = $SettingPanels/PnaelLightsBox/PanelLights/VBoxContainer/ButtonKitchen
onready var light_shack = $SettingPanels/PnaelLightsBox/PanelLights/VBoxContainer/ButtonShack
onready var button_bobbing = $SettingPanels/PanelViewer/VBoxContainer/HBoxContainer/ButtonBob
onready var button_collision = $SettingPanels/PanelViewer/VBoxContainer/HBoxContainer/ButtonCollision

onready var control_help = $ControlHelp
onready var toggle_controls = $ControlHelp/ToggleControlHelp

onready var performance = $PanelPerformance

const LOGO_VISIBLE_MARGIN = PoolRealArray([25, 25, 675, 425])
const LOGO_INVISIBLE_MARGIN = PoolRealArray([25, -200, 675, 200])

const TIME_VISIBLE_MARGIN = PoolRealArray([-282, 0, -26, 256])
const TIME_INVISIBLE_MARGIN = PoolRealArray([-282, -250, -26, 6])

const SETTINGS_VISIBLE_MARGIN = PoolRealArray([-397, -415, -26, -19])
const SETTINGS_INVISIBLE_MARGIN = PoolRealArray([10, -415, 382, -19])

const CONTROLS_SHOW_MARGIN = PoolRealArray([30, -248, 70, -208])
const CONTROLS_HIDE_MARGIN = PoolRealArray([30, -10, 70, 30])
const CONTROLS_INVISIBLE_MARGIN = PoolRealArray([30, 40, 70, 80])

onready var margin_array = [
		[logo, [LOGO_VISIBLE_MARGIN, LOGO_INVISIBLE_MARGIN]],
		[time_of_day, [TIME_VISIBLE_MARGIN, TIME_INVISIBLE_MARGIN]],
		[settings, [SETTINGS_VISIBLE_MARGIN, SETTINGS_INVISIBLE_MARGIN]]
				]

enum TransitionType {
		TRANS_LINEAR, TRANS_SINE, TRANS_QUINT, TRANS_QUART, TRANS_QUAD,
		TRANS_EXPO, TRANS_ELASTIC, TRANS_CUBIC, TRANS_CIRC, TRANS_BOUNCE,
		TRANS_BACK}
export (TransitionType) var toggle_transition

enum EaseType {EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN}
export (EaseType) var toggle_ease

export var tween_duration := 1.0

var is_visible := true setget _set_visible

var player
var time_manager
var lamps := {}


func _set_visible(new_state):
	if is_visible == new_state or tween.is_active():
		return
	
	is_visible = new_state
	
	if is_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		for i in margin_array:
			set_tween_margin(i[0], i[1][1], i[1][0], tween_duration, toggle_transition, toggle_ease)
		if toggle_controls.pressed:
			set_tween_margin(control_help, CONTROLS_INVISIBLE_MARGIN, CONTROLS_HIDE_MARGIN, tween_duration, toggle_transition, toggle_ease)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		for i in margin_array:
			set_tween_margin(i[0], i[1][0], i[1][1], tween_duration, toggle_transition, toggle_ease)
		if toggle_controls.pressed:
			set_tween_margin(control_help, CONTROLS_HIDE_MARGIN, CONTROLS_INVISIBLE_MARGIN, tween_duration, toggle_transition, toggle_ease)
		else:
			toggle_controls.pressed = true
			set_tween_margin(control_help, CONTROLS_SHOW_MARGIN, CONTROLS_INVISIBLE_MARGIN, tween_duration, toggle_transition, toggle_ease)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	if toggle_controls.pressed == true:
		toggle_controls.text = "Show"

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
	time_manager = get_tree().get_nodes_in_group("time_manager")[0]
	
	var lamp_nodes = get_tree().get_nodes_in_group("lamp")
	for lamp in lamp_nodes:
		lamps[lamp.id] = lamp
	
	time_menu.connect("item_selected", self, "_on_time_selected")
	
	light_hall.connect("toggled", self, "_toggle_light", ["hall"])
	light_kitchen.connect("toggled", self, "_toggle_light", ["kitchen"])
	light_shack.connect("toggled", self, "_toggle_light", ["shack"])
	
	button_bobbing.connect("toggled", self, "_toggle_bobbing")
	button_collision.connect("toggled", self, "_toggle_collision")
	
	toggle_controls.connect("pressed", self, "_on_toggle_controls_pressed")

func _on_time_selected(new_time: int) -> void:
	time_menu.disabled = true
	
	time_manager.setting = time_manager.times[new_time]
	
	tween.interpolate_property(time_image, "rect_rotation", time_image.rect_rotation, time_image.rect_rotation + 180.0, 1.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	time_menu.disabled = false

func _on_toggle_controls_pressed() -> void:
	toggle_controls.disabled = true
	
	if toggle_controls.pressed:
		if is_visible:
			set_tween_margin(control_help, CONTROLS_SHOW_MARGIN, CONTROLS_HIDE_MARGIN, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
		else:
			set_tween_margin(control_help, CONTROLS_SHOW_MARGIN, CONTROLS_INVISIBLE_MARGIN, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	else:
		if is_visible:
			set_tween_margin(control_help, CONTROLS_HIDE_MARGIN, CONTROLS_SHOW_MARGIN, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
		else:
			set_tween_margin(control_help, CONTROLS_INVISIBLE_MARGIN, CONTROLS_SHOW_MARGIN, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	if toggle_controls.pressed:
		toggle_controls.text = "Show"
	else:
		toggle_controls.text = "Hide"
	
	toggle_controls.disabled = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_ui"):
		self.is_visible = !is_visible
	
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F2:
			$PanelPerformance.visible = !$PanelPerformance.visible

func set_tween_margin(object: Object, from: PoolRealArray, to: PoolRealArray, duration: float, transition_type, ease_type) -> void:
	if not object is Control:
		return
	
	tween.interpolate_property(object, "margin_left", from[0], to[0], duration, transition_type, ease_type)
	tween.interpolate_property(object, "margin_top", from[1], to[1], duration, transition_type, ease_type)
	tween.interpolate_property(object, "margin_right", from[2], to[2], duration, transition_type, ease_type)
	tween.interpolate_property(object, "margin_bottom", from[3], to[3], duration, transition_type, ease_type)

func _toggle_light(pressed: bool, id: String) -> void:
	lamps[id].pattern = int(pressed)

func _toggle_bobbing(pressed: bool) -> void:
	player.float_effect = pressed

func _toggle_collision(pressed: bool) -> void:
	player.get_node("BodyCollision").disabled = !pressed
