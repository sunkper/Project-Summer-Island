tool
extends Spatial

var probes := []

func _ready() -> void:
	var children := get_children()
	for c in range(children.size()):
		if not children[c] is ReflectionProbe:
			children.remove(c)
	probes = children

func update_probes() -> void:
	for p in probes:
		p.update_mode = ReflectionProbe.UPDATE_ALWAYS
#	yield(get_tree(), "idle_frame")
	for p in probes:
		p.update_mode = ReflectionProbe.UPDATE_ONCE

func change_ambient_color(new_color: Color) -> void:
	for p in probes:
		if p.interior_enable:
			p.interior_ambient_color = new_color
