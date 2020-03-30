# LUMI (Line-Up MeshInstance)
# set instances on grid

tool
class_name LineUpMeshInstance
extends MultiMeshInstance

export (String, FILE) var node setget _set_mesh

export var shuffle:= false setget _shuffle

export var seedn:= 0 setget _set_seed

export var grid := Vector3(2, 2, 2) setget _set_grid
export var grid_random := Vector3(0, 0, 0) setget _set_grid_random

export var offset := Vector3(0.5, 0.5, 0.5) setget _set_offset
export var offset_random:= Vector3(0, 0, 0) setget _set_offset_random

export var rot := Vector3.ZERO setget _set_rot
export var rot_random:= Vector3.ZERO setget _set_rot_random

export var object_scale := Vector3.ONE setget _set_scale
export var object_scale_random:= Vector3.ZERO setget _set_scale_random


func _set_mesh(new_mesh) -> void:
	node = new_mesh
	if not new_mesh:
		return
	
	var n = load(node)
	var i = n.instance()
	var mesh
	if i is MeshInstance:
		mesh = i.mesh
	else:
		var children = i.get_children()
		for c in children:
			if c is MeshInstance:
				mesh = c.mesh
				break
	i.queue_free()
	
	_create_multimesh()
	multimesh.mesh = mesh

func _shuffle(s) -> void:
	_set_seed(randi() % 60000)
	update()

func _set_seed(new_seed: int) -> void:
	if new_seed == seedn:
		return
	
	seedn = new_seed
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

func _set_scale(new_scale: Vector3) -> void:
	if new_scale == object_scale:
		return
	
	object_scale = new_scale
	
	update()

func _set_scale_random(new_scale_random: Vector3) -> void:
	if new_scale_random == object_scale_random:
		return
	
	object_scale_random = new_scale_random
	
	update()

func _create_multimesh() -> void:
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D

func update() -> void:
	seed(seedn)
	var final_grid := grid
	
	if grid_random.x != 0.0:
		final_grid.x = final_grid.x + randi() % int(grid_random.x)
	if grid_random.y != 0.0:
		final_grid.y = final_grid.y + randi() % int(grid_random.y)
	if grid_random.z != 0.0:
		final_grid.z = final_grid.z + randi() % int(grid_random.z)
	
	multimesh.instance_count = int(final_grid.x * final_grid.y * final_grid.z)
	
	var i: = 0
	for x in range(int(final_grid.x)):
		for y in range(int(final_grid.y)):
			for z in range(int(final_grid.z)):
				var final_pos = _get_final_pos(offset, offset_random)
				var final_basis = _get_basis(rot, rot_random, object_scale, object_scale_random)
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

func _get_basis(rot_base: Vector3, rot_rand: Vector3, scale_base: Vector3, scale_rand: Vector3) -> Basis:
	var basis := Basis()
	
	if rot_rand != Vector3.ZERO:
		rot_base.x += rand_range(-rot_rand.x/2, rot_rand.x/2)
		rot_base.y += rand_range(-rot_rand.y/2, rot_rand.y/2)
		rot_base.z += rand_range(-rot_rand.z/2, rot_rand.z/2)
	
	if rot_base != Vector3.ZERO:
		# x rotation
		basis = basis.rotated(Vector3(1, 0, 0), deg2rad(rot_base.x))
		# y rotation
		basis = basis.rotated(Vector3(0, 1, 0), deg2rad(rot_base.y))
		# z rotation
		basis = basis.rotated(Vector3(0, 0, 1), deg2rad(rot_base.z))
	
	if scale_rand != Vector3.ZERO:
		scale_base.x += rand_range(-scale_rand.x/2, scale_rand.x/2)
		scale_base.y += rand_range(-scale_rand.y/2, scale_rand.y/2)
		scale_base.z += rand_range(-scale_rand.z/2, scale_rand.z/2)
	
	if scale_base != Vector3.ONE:
		basis = basis.scaled(scale_base)
	
	return basis
