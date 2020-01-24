tool
extends Node

# Current implementation: just switching between day and night

enum times {DAY, NIGHT}
export (times) var time setget _set_time

export (NodePath) var environment
export (NodePath) var dir_light

onready var panorama_day = preload("res://_TEMP_THEFT_ASSETS/textures/Boku2SkyDay.jpg")
onready var panorama_night = preload("res://_TEMP_THEFT_ASSETS/textures/Boku2SkyNight.jpg")

func _set_time(new_time) -> void:
	time = new_time
	if get_parent() == null:
		return
	if not get_parent().get_child_count() > 0:
		return
	var env = get_node(environment).environment
	
	match time:
		times.DAY:
			env.background_sky.panorama = panorama_day
			env.background_energy = 0.2
			get_node(dir_light).light_color = Color(0.98, 0.97, 0.93)
		times.NIGHT:
			env.background_sky.panorama = panorama_night
			env.background_energy = 0.2
			get_node(dir_light).light_color = Color(0.08, 0.12, 0.24)
