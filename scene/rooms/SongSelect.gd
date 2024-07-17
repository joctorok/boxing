extends Node2D

var songButton = preload("res://scene/rooms/song_button.tscn")
# Called when the node enters the scene tree for the first time.
var menuOption : int

var canInput : bool

func _ready():
	$AnimationPlayer.play("Scroll")
	$bg/AnimationPlayer.play("scroll")
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Scroll, "position:x", 100, .75)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property($Scroll, "position:y", 35, .75)
	tween2.finished.connect(start_input)
	for song in LevelManager.levelList:
		var chartInSong = readJSON("res://songs/"+song+"/" + song+".json")
		var button = songButton.instantiate()
		$Scroll/VBoxContainer.add_child(button)
		button.songName.text = chartInSong.song.name
		if FileAccess.file_exists("user://" + song + ".json"):
			var save = readJSON("user://" + song + ".json")
			button.tex = save.data.rank
		else:
			button.tex = 4
		button.position.y = 5 + LevelManager.levelList.find(song) * 60
		button.pressed.connect(switch_to_level.bind(button.get_index(false)))
	pass # Replace with function body.

func switch_to_level(x):
	LevelManager.go_to_level(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Scroll/VBoxContainer.position.y = lerp($Scroll/VBoxContainer.position.y, float(menuOption * -40), 0.25)
	menuOption = wrapi(menuOption, 0, len(LevelManager.levelList))
	for button in $Scroll/VBoxContainer.get_children():
		if menuOption == button.get_index(false):
			button.isSelected = true
		else:
			button.isSelected = false
	if canInput:
		if Input.is_action_just_pressed("ui_up"):
			$AudioStreamPlayer2D.play(0.028)
			menuOption -= 1
		elif Input.is_action_just_pressed("ui_down"):
			$AudioStreamPlayer2D.play(0.028)
			
			menuOption += 1
	if Input.is_action_just_pressed("gm_quit"):
		SceneSwitcher.start_transition("res://scene/rooms/menu.tscn", 0)
	pass

func start_input():
	canInput = true

func readJSON(path : String):
	var json  = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(json.get_as_text())
