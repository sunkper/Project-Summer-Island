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
		$Sound.play()
		$Viewport/ColorRect.visible = false
		$Screen.material_override.emission_enabled = true
	else:
		$Viewport/VideoPlayer.stop()
		$Sound.stop()
		$Viewport/ColorRect.visible = true
		$Screen.material_override.emission_enabled = false
