extends CanvasLayer

export (float, 0.0, 10.0) var lifetime : float

func _ready():
	$Timer.wait_time = lifetime

func push() -> void:
	pass


