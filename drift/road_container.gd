extends Node3D

@export var segment_scene: PackedScene
@export var vehicle: Node3D
@export var count: int = 10
@export var segment_length: float = 40.0
@export var segments_behind: int = 5

var road_segments: Array = []

func _physics_process(delta):
	if vehicle == null or road_segments.is_empty():
		return
	
	var player_z = vehicle.global_transform.origin.z
	var last_segment = road_segments[-1]
	var last_z = last_segment.global_transform.origin.z
	
	# Spawn ahead
	while player_z + (count * segment_length) > last_z:
		var seg = segment_scene.instantiate()
		add_child(seg)
		
		var new_z = last_z + segment_length
		seg.position = Vector3(0, 0, new_z)
		
		road_segments.append(seg)
		last_z = new_z
	
	# Cleanup behind
	for seg in road_segments:
		if seg.global_transform.origin.z < player_z - (segments_behind * segment_length):
			seg.queue_free()
			road_segments.erase(seg)
