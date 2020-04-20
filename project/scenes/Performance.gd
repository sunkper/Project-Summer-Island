extends Label

func _process(delta: float) -> void:
	text = print_perf()

func print_perf() -> String:
	var format := "FPS: %d | Draw Calls: %d | Video Mem: %.2f MiB"

	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var dc = Performance.get_monitor(Performance.RENDER_DRAW_CALLS_IN_FRAME)
	var vm = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / (1024 * 1024)

	var out = format % [fps, dc, vm]
	
	return out
