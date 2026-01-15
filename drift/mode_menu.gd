extends Node3D

func _ready():
	$VBoxContainer/freies_Spiel.pressed.connect(_on_freies_Spiel_pressed)
	$VBoxContainer/Timer.pressed.connect(_on_timer_pressed)
	$VBoxContainer/Punkte.pressed.connect(_on_punkte_pressed)
	$VBoxContainer/Zurück.pressed.connect(_on_zurück_pressed)

func _on_freies_Spiel_pressed():
	print("Modus 1 gewählt")
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_timer_pressed():
	print("Modus 2 gewählt")
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_punkte_pressed():
	print("Modus 3 gewählt")
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_zurück_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
