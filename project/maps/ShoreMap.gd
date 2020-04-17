extends Node

onready var kitchen_godette = $Characters/GodetteKitchen

func _ready() -> void:
	randomize()
	$Objects/ShrineRoom/DiamondGodetue/Shrine.connect("secret_found", self, "_on_secret_found")

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F5:
			$DayOfTime.setting = $DayOfTime.times[0]
		if event.scancode == KEY_F6:
			$DayOfTime.setting = $DayOfTime.times[1]
		if event.scancode == KEY_F7:
			if $Lightings/HangingLamp.pattern == $Lightings/HangingLamp.patterns.ON:
				$Lightings/HangingLamp.pattern = $Lightings/HangingLamp.patterns.OFF
			else:
				$Lightings/HangingLamp.pattern = $Lightings/HangingLamp.patterns.ON
		if event.scancode == KEY_F8:
			if $Lightings/HangingLamp2.pattern == $Lightings/HangingLamp2.patterns.ON:
				$Lightings/HangingLamp2.pattern = $Lightings/HangingLamp2.patterns.OFF
			else:
				$Lightings/HangingLamp2.pattern = $Lightings/HangingLamp2.patterns.ON

func _on_secret_found() -> void:
	kitchen_godette.translation = Vector3(5.277, 6.056, 4.64)
	kitchen_godette.rotation_degrees = Vector3(0.0, 43.357, 0.0)
	kitchen_godette.current_anim = "Idle"
