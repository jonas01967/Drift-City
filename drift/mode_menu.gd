extends Control

func _ready():
	$"VBoxContainer/freies Spiel".pressed.connect(_on_modus1_pressed)
	$VBoxContainer/Timer.pressed.connect(_on_modus2_pressed)
	$VBoxContainer/Punkte.pressed.connect(_on_modus3_pressed)
	$"VBoxContainer/Zurück".pressed.connect(_on_zurueck_pressed)

func _on_freies_Spiel_pressed():
	print("Modus 1 gewählt")

func _on_Timer_pressed():
	print("Modus 2 gewählt")

func _on_Punkte_pressed():
	print("Modus 3 gewählt")

func _on_Zurück_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
