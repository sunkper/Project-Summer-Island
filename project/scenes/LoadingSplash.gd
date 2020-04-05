extends Control

func _ready():
	yield($Camera/Anim, "animation_finished")
	$Camera/Anim.playback_speed = 0.03
	$Camera/Anim.play("CameraSwing")
