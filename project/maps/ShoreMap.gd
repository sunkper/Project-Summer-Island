extends Node

func _ready() -> void:
	randomize()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1:
			$DayOfTime.setting = $DayOfTime.times[0]
		if event.scancode == KEY_2:
			$DayOfTime.setting = $DayOfTime.times[1]
		if event.scancode == KEY_3:
			if $Lightings/HangingLamp.pattern == $Lightings/HangingLamp.patterns.ON:
				$Lightings/HangingLamp.pattern = $Lightings/HangingLamp.patterns.OFF
			else:
				$Lightings/HangingLamp.pattern = $Lightings/HangingLamp.patterns.ON
		if event.scancode == KEY_4:
			if $Lightings/HangingLamp2.pattern == $Lightings/HangingLamp2.patterns.ON:
				$Lightings/HangingLamp2.pattern = $Lightings/HangingLamp2.patterns.OFF
			else:
				$Lightings/HangingLamp2.pattern = $Lightings/HangingLamp2.patterns.ON
