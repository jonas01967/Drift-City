extends Node3D

@export var vehicle_scene: PackedScene
@export var road_container_path: NodePath = NodePath("RoadContainer")
@export var road_height: float = 0.2

var vehicle: VehicleBody3D

func _ready() -> void:
	_spawn_vehicle()

func _spawn_vehicle() -> void:
	if vehicle_scene == null:
		push_error("Vehicle scene is NULL")
		return

	var instance = vehicle_scene.instantiate()

	if not instance is VehicleBody3D:
		push_error("Scene is not a VehicleBody3D")
		return

	vehicle = instance as VehicleBody3D
	add_child(vehicle)

	vehicle.global_position = Vector3(0, road_height / 2.0 + 1.0, 0)
	_set_road_container_vehicle()

func _set_road_container_vehicle() -> void:
	var road_container = get_node_or_null(road_container_path)
	if road_container == null:
		road_container = get_node_or_null("RoadContainer")
	if road_container != null:
		road_container.set("vehicle", vehicle)
