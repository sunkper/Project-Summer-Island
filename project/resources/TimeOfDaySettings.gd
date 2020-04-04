class_name TimeOfDaySettings
extends Resource

export (String, MULTILINE) var note = ""

export (String, FILE) var sky_panorama := ""

export (float, 0.0, 1.0) var background_energy := 1.0

export (Color) var sunlight_color := Color(1.0, 1.0, 1.0)

export (float, 0.0, 10.0) var sun_indirect_energy := 1.0

export (Vector3) var sun_direction := Vector3(-90.0, 0.0, 0.0)

export (Vector3) var sky_rotation := Vector3(0.0, 0.0, 0.0)

export (float, 0.0, 2.0) var sun_godrays_exposure := 0.5

export (float, 0.0, 2.0) var sun_godrays_light_size := 0.5

export (Color) var ambient_light_color := Color(0.0, 0.0, 0.0)

export (float, 0.0, 16.0) var ambient_light_energy := 1.0

export (float, 0.0, 1.0) var ambient_light_sky_contribution := 1.0

export (Color) var refprobe_ambient_color := Color(0.0, 0.0, 0.0)

export (Color) var fog_color := Color(0.5, 0.5, 0.5)

export (Color) var fog_sun_color := Color(1.0, 0.9, 0.7)

export (float, 0.0, 4000.0) var fog_depth_begin := 10.0

export (float, 0.0, 4000.0) var fog_depth_end := 100.0

export (float, EASE) var fog_depth_curve := 1.0
