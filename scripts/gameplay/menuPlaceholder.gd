extends Node2D

@onready var title : = $Title
@onready var introSound : = $Intro
@onready var menuOptions : = $MainMenu
@onready var trackList : = $TrackList

@onready var songSelect : = $MainMenu/SongSelect
@onready var exit : = $MainMenu/ExitToStart
@onready var text : = $Title/Label


@onready var tutorial : = $TrackList/Tutorial
@onready var round1 : = $TrackList/Round1

var menuColor : int

# Called when the node enters the scene tree for the first time.
func _ready():
	menuColor = randi_range(1, 3)
	introSound.play()
	$bg/AnimationPlayer.play("scroll")
	match menuColor:
		1:
			$bg.modulate = Color(0.523, 0.869, 1, 1)
		2:
			$bg.modulate = Color(1, 0.488, 0.801, 1)
		3:
			$bg.modulate = Color(0.733, 1, 0.878, 1)
	
	if MenuState.state == MenuState.s.Start:
		title.position.y = 240
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(title, "position:y", 96, .75)
		LevelManager.currentLevel = ""
	else:
		$Music.play()
		
	pass # Replace with function body.


func _process(delta):
	match MenuState.state:
		MenuState.s.Start:
			songSelect.disabled = true
			exit.disabled = true
			if Input.is_action_just_pressed("ui_accept"):
				MenuState.state = MenuState.s.Menu
		MenuState.s.Menu:
			set_menu()
		MenuState.s.SongSelect:
			set_song_select()

func set_song_select():
	if trackList.position.y == 192:
		$Sidebar.position.x = 144
		menuOptions.position.x = 150
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(menuOptions, "position:y", -120, 0.50)
		title.position.x = 64
		var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween2.tween_property(trackList, "position:y", 24, 0.50)
		var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween3.tween_property(text, "theme_override_colors/font_color:a", 0, 0.50)
	songSelect.disabled = true
	exit.disabled = true
	tutorial.disabled = false
	round1.disabled = false

func set_menu():
	if menuOptions.position.x == 256:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(menuOptions, "position:x", 150, 0.50)
		var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween2.tween_property(title, "position:x", 64, 0.50)
		var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween3.tween_property(text, "theme_override_colors/font_color:a", 0, 0.50)
		var tween4 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween4.tween_property(text, "theme_override_colors/font_outline_color:a", 0, 0.50)
		var tween5 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween5.tween_property($Sidebar, "position:x", 144, 0.50)
	songSelect.disabled = false
	exit.disabled = false
	tutorial.disabled = true
	round1.disabled = true

func _on_exit_to_start_pressed():
	MenuState.state = MenuState.s.Start
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(menuOptions, "position:x", 256, 0.50)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property(title, "position:x", 128, 0.50)
	songSelect.disabled = false
	exit.disabled = false
	var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween3.tween_property(text, "theme_override_colors/font_color:a", 1, 0.50)
	var tween4 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween4.tween_property(text, "theme_override_colors/font_outline_color:a", 1, 0.50)
	var tween5 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween5.tween_property($Sidebar, "position:x", 264, 0.50)
	pass # Replace with function body.

func _on_song_select_pressed():
	SceneSwitcher.start_transition("res://scene/rooms/SongSelect.tscn", 0)
	pass # Replace with function body.

func _on_back_to_menu_pressed():
	MenuState.state = MenuState.s.Menu
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(menuOptions, "position:y", 40, 0.50)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property(trackList, "position:y", 192, 0.50)
	pass # Replace with function body.

func _on_round_1_pressed():
	LevelManager.go_to_level(1)
	pass # Replace with function body.

func _on_tutorial_pressed():
	LevelManager.go_to_level(0)
	pass # Replace with function body.

func _on_intro_finished():
	if $Music.playing == false:
		$Music.play()
	if MenuState.state == MenuState.s.Start:
		var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween3.tween_property(text, "theme_override_colors/font_color:a", 1, 0.50)
		var tween4 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween4.tween_property(text, "theme_override_colors/font_outline_color:a", 1, 0.50)
	pass # Replace with function body.

func _on_round_2_pressed():
	LevelManager.go_to_level(2)
	pass # Replace with function body.
