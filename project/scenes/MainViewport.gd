extends Control

var player_init_pos = [Vector3(8.2, 19.38, -30.70), Vector3(0, -180, 0)]
var player_cache_pos = [Vector3(135, 35, 174), Vector3(0, 35, 0)]

# Screenshot capture code by Filip Lundby, https://twitter.com/skooterkurt
# https://github.com/FilipLundby/godot-snippets/blob/master/Screenshot.gd
var _screenshot_directory = "user://screenshots"
var _capture_tasks = []

var scale_factor := 1.0 setget _scale_factor_changed

func _scale_factor_changed(new_value) -> void:
	scale_factor = new_value
	_root_viewport_size_changed()

func _ready() -> void:
	get_viewport().connect("size_changed", self, "_root_viewport_size_changed")
	Directory.new().make_dir(_screenshot_directory)

func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F12:
			_capture()
		if event.scancode == KEY_F11:
			OS.window_fullscreen = !OS.window_fullscreen

func _capture():
	# Start thread for capturing images
	var task = Thread.new()
	task.start(self, "_capture_thread", null)
	_capture_tasks.append(task)

func _capture_thread(_arg):
	# Save image
	var image = get_viewport().get_texture().get_data()
	var path = "%s/capture_%s.png" % [_screenshot_directory, OS.get_unix_time()]
	image.flip_y()
	image.save_png(path)
	print ("Screenshot saved to: %s%s" % [OS.get_user_data_dir(), path])

func _exit_tree():
	for task in _capture_tasks:
		task.wait_to_finish()

func _root_viewport_size_changed() -> void:
	$Viewport.size = get_viewport().size * scale_factor

func _on_main_load_finished(splash, loading_text) -> void:
	var player = $Viewport/ShoreMap/Player
	
	# Temporaily move player to a position that can see the entire map
	# to reduce stutter/freeze after the initial one
	print("moving player to cache position...")
	player.translation = player_cache_pos[0]
	player.rotation_degrees = player_cache_pos[1]
	
	yield(get_tree(), "idle_frame")
	
	print("get player back to init position...")
	player.translation = player_init_pos[0]
	player.rotation_degrees = player_init_pos[1]
	
	yield(get_tree(), "idle_frame")
	
	print("removing loading screen...")
	splash.queue_free()
	loading_text.queue_free()
