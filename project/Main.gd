extends Node

export (String, FILE) var scene_to_load

var queue


func _ready():
	# Initialize.
	queue = preload("res://scenes/ResourceQueue.gd").new()
	# Call after you instance the class to start the thread.
	queue.start()
	set_process(true)
	# Queue a resource.
	queue.queue_resource(scene_to_load, true)

func _process(_delta):
	# Returns true if a resource is done loading and ready to be retrieved.
	if queue.is_ready(scene_to_load):
		set_process(false)
		# Returns the fully loaded resource.
		var next_scene = queue.get_resource(scene_to_load).instance()
		add_child(next_scene)
		$LoadingSplash.queue_free()
		$LoadingUI/LoadingText.hide()
	else:
		# Get the progress of a resource.
		var progress = round(queue.get_progress(scene_to_load) * 100)
		get_node("ProgressBar").set_value(progress)
