extends Spatial

export var switch: = false setget _toggle_switch

func _toggle_switch(new_state) -> void:
	if not has_node("Model/Sound"):
		return
	
	switch = new_state
	turn_on_tv(switch)

func turn_on_tv(state: bool) -> void:
	if state:
		$Viewport/VideoPlayer.play()
		$Model/Sound.play()
		$Viewport/ColorRect.visible = false
		$Model/Screen.material_override.emission_enabled = true
	else:
		$Viewport/VideoPlayer.stop()
		$Model/Sound.stop()
		$Viewport/ColorRect.visible = true
		$Model/Screen.material_override.emission_enabled = false
