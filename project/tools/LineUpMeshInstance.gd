tool
extends MultiMeshInstance

export (String, FILE) var node setget _set_mesh

export var shuffle: = false setget _shuffle

export var grid := Vector3(2, 2, 2) setget _set_grid
export var grid_random := Vector3(0, 0, 0) setget _set_grid_random

export var offset := Vector3(0.5, 0.5, 0.5) setget _set_offset
export var offset_random:= Vector3(0, 0, 0) setget _set_offset_random

export var rot := Vector3(0.0, 0.0, 0.0) setget _set_rot
export var rot_random:= Vector3(0.0, 0.0, 0.0) setget _set_rot_random


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

func _set_rot(new_rot: Vector3) -> void:
	if new_rot == rot:
		return
	
	rot = new_rot
	update()

func _set_rot_random(new_rot_random: Vector3) -> void:
	if new_rot_random == rot_random:
		return
	
	rot_random = new_rot_random
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
				var final_pos = _get_final_pos(offset, offset_random)
				var final_basis = _get_basis(rot, rot_random)
				var xform = Transform(final_basis, Vector3(x * final_pos.x, y * final_pos.y, z * final_pos.z))
				multimesh.set_instance_transform(i, xform)
				i += 1

func _get_final_pos(base: Vector3, rand: Vector3) -> Vector3:
	if rand.x != 0.0:
		base.x = base.x + rand_range(0.0, rand.x)
	if rand.y != 0.0:
		base.y = base.y + rand_range(0.0, rand.y)
	if rand.z != 0.0:
		base.z = base.z + rand_range(0.0, rand.z)
	
	return base

func _get_basis(base: Vector3, rand: Vector3) -> Basis:
	var basis := Basis()
	if base == Vector3() and rand == Vector3():
		return basis
	
	if rand.x != 0.0:
		base.x = base.x + rand_range(0.0, rand.x)
	if rand.y != 0.0:
		base.y = base.y + rand_range(0.0, rand.y)
	if rand.z != 0.0:
		base.z = base.z + rand_range(0.0, rand.z)
	
	# x rotation
	basis = basis.rotated(Vector3(1, 0, 0), deg2rad(base.x))
	# y rotation
	basis = basis.rotated(Vector3(0, 1, 0), deg2rad(base.y))
	# z rotation
	basis = basis.rotated(Vector3(0, 0, 1), deg2rad(base.z))
	
	return basis
