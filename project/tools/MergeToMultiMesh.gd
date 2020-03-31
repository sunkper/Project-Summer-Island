# Merge children into a MultiMeshInstance node.
# Simply take mesh from the first child and xforms from all Spatial children

tool
class_name MergeToMultiMesh
extends MultiMeshInstance

export (bool) var merge := false setget _merge

# Whether or not remove nodes after creating MultiMeshInstance
# This removes all children, Spatial or not
export (bool) var remove_children_after := true

var mesh: Mesh

func _merge(new_state) -> void:
	mesh = _get_mesh(get_child(0))
	var transforms = _get_transforms()
	multimesh = create_multimesh(transforms)
	
	if remove_children_after:
		for c in get_children():
			remove_child(c)

func _get_mesh(node):
	var result: Mesh
	if node is MeshInstance:
			result = node.mesh
	else:
		for c in node.get_children():
			if c is MeshInstance:
				result = c.mesh
				break
	
	return result

func _get_transforms() -> Array:
	var transforms: Array
	
	for c in get_children():
		if c is Spatial:
			transforms.append(c.transform)
	
	return transforms

func create_multimesh(transforms: Array) -> MultiMesh:
	var result := MultiMesh.new()
	result.transform_format = MultiMesh.TRANSFORM_3D
	result.mesh = mesh
	result.instance_count = transforms.size()
	for i in range(transforms.size()):
		result.set_instance_transform(i, transforms[i])
	
	return result
