extends Node3D

func _ready():
	$VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$VBoxContainer/Modi.pressed.connect(_on_modi_pressed)
	$VBoxContainer/Beenden.pressed.connect(_on_beenden_pressed)

func _on_start_pressed():
	print("Spiel starten (hier später Level laden)")

func _on_modi_pressed():
	get_tree().change_scene_to_file("res://mode_menu.tscn")

func _on_beenden_pressed():
	get_tree().quit()
