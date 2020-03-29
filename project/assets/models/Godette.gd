tool
extends Spatial

export (String, "Idle", "Walking", "CrossingArms", "AThing", "Surprised") var current_anim = "Idle" setget _change_anim

func _change_anim(new_anim: String):
	current_anim = new_anim
	$Model/AnimationPlayer.play(current_anim)

func _ready() -> void:
	$Model/AnimationPlayer.play(current_anim)
