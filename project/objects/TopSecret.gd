extends Area

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	$SecretSound.play()
	set_deferred("monitoring", false)
