extends Node

func _ready() -> void:
	randomize()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if $DayNightCycle.time == $DayNightCycle.times.DAY:
			$DayNightCycle.time = $DayNightCycle.times.NIGHT
		else:
			$DayNightCycle.time = $DayNightCycle.times.DAY
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1:
			if $Lightings/HangingLamp.pattern == $Lightings/HangingLamp.patterns.ON:
				$Lightings/HangingLamp.pattern = $Lightings/HangingLamp.patterns.OFF
			else:
				$Lightings/HangingLamp.pattern = $Lightings/HangingLamp.patterns.ON
		if event.scancode == KEY_2:
			if $Lightings/HangingLamp2.pattern == $Lightings/HangingLamp2.patterns.ON:
				$Lightings/HangingLamp2.pattern = $Lightings/HangingLamp2.patterns.OFF
			else:
				$Lightings/HangingLamp2.pattern = $Lightings/HangingLamp2.patterns.ON
