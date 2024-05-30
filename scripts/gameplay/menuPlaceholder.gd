extends Node2D

@onready var title : = $Title
@onready var menuOptions : = $MainMenu
@onready var trackList : = $TrackList

@onready var storyMode : = $MainMenu/StoryMode
@onready var songSelect : = $MainMenu/SongSelect
@onready var exit : = $MainMenu/ExitToStart
@onready var text : = $Title/Label


@onready var tutorial : = $TrackList/Tutorial
@onready var round1 : = $TrackList/Round1



# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.currentLevel = ""
	pass # Replace with function body.

func _process(delta):
	match MenuState.state:
		MenuState.s.Start:
			storyMode.disabled = true
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
		menuOptions.position.x = 150
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(menuOptions, "position:y", -104, 0.50)
		title.position.x = 64
		var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween2.tween_property(trackList, "position:y", 40, 0.50)
		var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween3.tween_property(text, "theme_override_colors/font_color:a", 0, 0.50)
	LevelManager.inStoryMode = false
	storyMode.disabled = true
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
	storyMode.disabled = false
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
	storyMode.disabled = false
	songSelect.disabled = false
	exit.disabled = false
	var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween3.tween_property(text, "theme_override_colors/font_color:a", 1, 0.50)
	pass # Replace with function body.


func _on_story_mode_pressed():
	LevelManager.inStoryMode = true
	LevelManager.go_to_level(0)
	pass # Replace with function body.


func _on_song_select_pressed():
	MenuState.state = MenuState.s.SongSelect
	pass # Replace with function body.


func _on_back_to_menu_pressed():
	MenuState.state = MenuState.s.Menu
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(menuOptions, "position:y", 40, 0.50)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property(trackList, "position:y", 192, 0.50)
	pass # Replace with function body.


func _on_round_1_pressed():
	LevelManager.go_to_level(2)
	pass # Replace with function body.


func _on_tutorial_pressed():
	LevelManager.go_to_level(0)
	pass # Replace with function body.
