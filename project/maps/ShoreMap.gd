extends Node

onready var kitchen_godette = $Characters/GodetteKitchen

func _ready() -> void:
	randomize()
	$Objects/ShrineRoom/DiamondGodetue/Shrine.connect("secret_found", self, "_on_secret_found")

func _on_secret_found() -> void:
	kitchen_godette.translation = Vector3(5.277, 6.056, 4.64)
	kitchen_godette.rotation_degrees = Vector3(0.0, 43.357, 0.0)
	kitchen_godette.current_anim = "Idle"
