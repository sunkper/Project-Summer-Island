extends Area

signal secret_found()

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	emit_signal("secret_found")
	$SecretSound.play()
	set_deferred("monitoring", false)
	yield($SecretSound, "finished")
	queue_free()
