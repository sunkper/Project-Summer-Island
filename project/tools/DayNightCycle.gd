tool
extends Node

# drag one of custom resources from 'times' to 'setting'
export (Array, Resource) var times = []
export (Resource) var setting setget _change_setting

export (NodePath) var environment_path
export (NodePath) var sunlight_path
export (NodePath) var refprobe_manager_path
export (Array, NodePath) var giprobes

func _change_setting(new_setting) -> void:
	if setting == new_setting:
		return
	setting = new_setting
	if get_node(environment_path) != null:
		_set_day_env()

func _set_day_env() -> void:
	var env = get_node(environment_path).environment
	var sun = get_node(sunlight_path)
	var rp_manager = get_node(refprobe_manager_path)
	
	var panorama = load(setting.sky_panorama)
	env.background_sky.panorama = panorama
	env.background_energy = setting.background_energy
	env.background_sky_rotation_degrees = setting.sky_rotation
	sun.light_color = setting.sunlight_color
	sun.light_indirect_energy = setting.sun_indirect_energy
	sun.get_node("GodRays").exposure = setting.sun_godrays_exposure
	sun.get_node("GodRays").light_size = setting.sun_godrays_light_size
	sun.rotation_degrees = setting.sun_direction
	env.ambient_light_color = setting.ambient_light_color
	env.ambient_light_energy = setting.ambient_light_energy
	env.ambient_light_sky_contribution = setting.ambient_light_sky_contribution
	rp_manager.change_ambient_color(setting.refprobe_ambient_color)
	env.fog_color = setting.fog_color
	env.fog_sun_color = setting.fog_sun_color
	env.fog_depth_begin = setting.fog_depth_begin
	env.fog_depth_end = setting.fog_depth_end
	env.fog_depth_curve = setting.fog_depth_curve
	
	if setting.signal_to_send:
		emit_signal(setting.signal_to_send)
	
	rp_manager.update_probes()

func _ready() -> void:
	_set_day_env()
