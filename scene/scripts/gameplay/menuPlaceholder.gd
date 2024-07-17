extends Node2D

@onready var title : = $Title
@onready var introSound : = $Intro
@onready var text : = $Title/Label


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
			if Input.is_action_just_pressed("ui_accept"):
				SceneSwitcher.start_transition("res://scene/rooms/SongSelect.tscn", 0)
	
func _on_intro_finished():
	if $Music.playing == false:
		$Music.play()
	if MenuState.state == MenuState.s.Start:
		var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween3.tween_property(text, "theme_override_colors/font_color:a", 1, 0.50)
		var tween4 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween4.tween_property(text, "theme_override_colors/font_outline_color:a", 1, 0.50)
	pass # Replace with function body.
