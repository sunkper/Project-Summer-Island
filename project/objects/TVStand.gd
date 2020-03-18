tool
extends Spatial

export var switch: = false setget _toggle_switch

func _toggle_switch(new_state) -> void:
	if new_state == switch:
		return
	
	if get_child_count() == 0:
		return
	
	switch = new_state
	if switch:
		$Viewport/VideoPlayer.play()
		$Model/Sound.play()
		$Viewport/ColorRect.visible = false
		$Model/Screen.material_override.emission_enabled = true
	else:
		$Viewport/VideoPlayer.stop()
		$Model/Sound.stop()
		$Viewport/ColorRect.visible = true
		$Model/Screen.material_override.emission_enabled = false
