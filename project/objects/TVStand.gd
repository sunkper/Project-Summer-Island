extends Spatial

#export var turn_on: = false setget _turn_onoff
#
#func _turn_onoff(new_state) -> void:
#	if new_state == turn_on:
#		return
#
#	turn_on = new_state
#	if has_node("Screen/Viewport/VideoPlayer"):
#		if turn_on:
#			$TV/Screen/Viewport/VideoPlayer.play()
#			$TVLight.flicker = true
#		else:
#			$TV/Screen/Viewport/VideoPlayer.stop()
#			$TVLight.flicker = false
