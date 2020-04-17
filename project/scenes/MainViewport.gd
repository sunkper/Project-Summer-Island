extends Control

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
		if event.scancode == KEY_F1:
			$DebugUI/ControlHelpPanel.visible = !$DebugUI/ControlHelpPanel.visible
		if event.scancode == KEY_F2:
			$DebugUI/Performance.visible = !$DebugUI/Performance.visible
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
