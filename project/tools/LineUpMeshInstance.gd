tool
extends MultiMeshInstance

export (String, FILE) var node setget _set_mesh

export var shuffle: = false setget _shuffle

export var grid := Vector3(2, 2, 2) setget _set_grid
export var grid_random := Vector3(0, 0, 0) setget _set_grid_random

export var offset := Vector3(0.5, 0.5, 0.5) setget _set_offset
export var offset_random: = Vector3(0, 0, 0) setget _set_offset_random


func _set_mesh(new_mesh) -> void:
	node = new_mesh
	if not new_mesh:
		return
	
	var n = load(node)
	var i = n.instance()
	var children = i.get_children()
	var mesh_node
	for c in children:
		if c is MeshInstance:
			mesh_node = c
			break
	i.queue_free()
	
	_create_multimesh()
	multimesh.mesh = mesh_node.mesh

func _shuffle(s) -> void:
	update()

func _set_grid(new_grid: Vector3) -> void:
	if grid == new_grid:
		return
	
	new_grid = new_grid.floor()
	new_grid.x = max(new_grid.x, 1.0)
	new_grid.y = max(new_grid.y, 1.0)
	new_grid.z = max(new_grid.z, 1.0)
	grid = new_grid
	update()

func _set_grid_random(new_grid_random: Vector3) -> void:
	if grid_random == new_grid_random:
		return
	
	new_grid_random = new_grid_random.floor()
	new_grid_random.x = max(new_grid_random.x, 0.0)
	new_grid_random.y = max(new_grid_random.y, 0.0)
	new_grid_random.z = max(new_grid_random.z, 0.0)
	grid_random = new_grid_random
	update()

func _set_offset(new_offset: Vector3) -> void:
	if new_offset == offset:
		return
	
	offset = new_offset
	update()

func _set_offset_random(new_offset_random: Vector3) -> void:
	if new_offset_random == offset_random:
		return
	
	offset_random = new_offset_random
	update()

func _create_multimesh() -> void:
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D

func update() -> void:
	var final_grid := grid
	
	if grid_random.x != 0.0:
		final_grid.x = final_grid.x + randi() % int(grid_random.x)
	if grid_random.y != 0.0:
		final_grid.y = final_grid.y + randi() % int(grid_random.y)
	if grid_random.z != 0.0:
		final_grid.z = final_grid.z + randi() % int(grid_random.z)
	
	var count: = int(final_grid.x * final_grid.y * final_grid.z)
	multimesh.instance_count = count
	
	var i: = 0
	for x in range(int(final_grid.x)):
		for y in range(int(final_grid.y)):
			for z in range(int(final_grid.z)):
				var final_offset = _get_offset(offset, offset_random)
				var xform = Transform(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(x * final_offset.x, y * final_offset.y, z * final_offset.z))
				multimesh.set_instance_transform(i, xform)
				i += 1

func _get_offset(base: Vector3, random_range: Vector3) -> Vector3:
	if random_range.x != 0.0:
		base.x = base.x + rand_range(0.0, random_range.x)
	if random_range.y != 0.0:
		base.y = base.y + rand_range(0.0, random_range.y)
	if random_range.z != 0.0:
		base.z = base.z + rand_range(0.0, random_range.z)
	
	return base
