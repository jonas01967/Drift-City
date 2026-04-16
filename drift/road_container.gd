extends Node3D

@export var segment_scene: PackedScene
@export var vehicle: Node3D
@export var count: int = 10
@export var segment_length: float = 40.0
@export var segments_behind: int = 5

var road_segments: Array = []

func _ready() -> void:
	if segment_scene == null:
		segment_scene = load("res://RoadSegment.tscn") as PackedScene
		if segment_scene == null:
			push_error("RoadContainer: segment_scene is NULL and fallback load failed")
			return

	_spawn_initial_segments()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if vehicle == null:
		_find_vehicle()
		if vehicle == null:
			return

	if road_segments.is_empty():
		_spawn_initial_segments()
		return

	var player_z = vehicle.global_transform.origin.z
	var last_segment = road_segments[-1]
	var last_z = last_segment.global_transform.origin.z

	while player_z + (count * segment_length) > last_z:
		var seg = _spawn_segment(last_z)
		if seg != null:
			road_segments.append(seg)
			last_z = seg.global_transform.origin.z
		else:
			break

	for seg in road_segments.duplicate():
		if seg.global_transform.origin.z < player_z - (segments_behind * segment_length):
			road_segments.erase(seg)
			seg.queue_free()

func _spawn_initial_segments() -> void:
	if segment_scene == null:
		return

	if vehicle == null:
		_find_vehicle()

	var previous_z = -segment_length
	for i in range(count):
		var seg = _spawn_segment(previous_z)
		if seg != null:
			road_segments.append(seg)
			previous_z += segment_length

func _spawn_segment(previous_z: float) -> Node3D:
	var seg = segment_scene.instantiate()
	if seg == null:
		push_error("RoadContainer: failed to instantiate segment_scene")
		return null
	if not seg is Node3D:
		push_error("RoadContainer: segment_scene did not instantiate a Node3D")
		seg.queue_free()
		return null

	add_child(seg)
	var new_z = previous_z + segment_length
	seg.position = Vector3(0, 0, new_z)
	return seg

func _find_vehicle() -> void:
	if vehicle != null:
		return

	var root = get_tree().get_current_scene()
	if root != null:
		vehicle = root.get_node_or_null("VehicleBody3D")
		if vehicle == null:
			vehicle = root.find_child("VehicleBody3D", true, false) as Node3D

	if vehicle == null:
		for node in get_tree().get_nodes_in_group("vehicle"):
			vehicle = node as Node3D
			break
