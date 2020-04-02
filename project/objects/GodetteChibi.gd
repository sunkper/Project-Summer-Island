tool
extends Spatial

enum Anims {T_POSE, STANDING, TADA, SALUTE, THINKING, FIGHT, RUNNING, PEWPEW, JUMPING, NUMBERONEIDOL}

# Name : Vector2(start_time, length)
var timestamps = {Anims.T_POSE : Vector2(0.0, 0.0), Anims.STANDING : Vector2(0.1, 0.0),
				Anims.TADA : Vector2(0.5, 1.1), Anims.SALUTE : Vector2(1.7, 0.6),
				Anims.THINKING : Vector2(3.2, 0.0), Anims.FIGHT : Vector2(4.3, 0.0),
				Anims.RUNNING : Vector2(5.8, 1.0), Anims.PEWPEW : Vector2(7.4, 1.2),
				Anims.JUMPING : Vector2(9.2, 1.7), Anims.NUMBERONEIDOL : Vector2(10.9, 1.8)}

func _ready() -> void:
	$Model/AnimationPlayer.play("ArmatureAction", 0.8)
