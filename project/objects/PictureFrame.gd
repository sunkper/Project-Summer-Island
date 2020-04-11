tool
extends Spatial

export (String, FILE) var picture setget _set_picture

func _set_picture(new_picture) -> void:
	if has_node("Picture") and new_picture != picture:
		var file = load(new_picture)
		if file is StreamTexture:
			picture = new_picture
			$Picture.mesh.material.set_shader_param("texture_albedo", file)
