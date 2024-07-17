extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Textbox.label.text = "It ain't over yet! Press SPACE to try again! If you're ready to throw in the towel, press ESCAPE."
	$AnimationPlayer.play("player_death")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		LevelManager.go_to_level(LevelManager.levelIndex)
	if Input.is_action_just_pressed("ui_cancel"):
		SceneSwitcher.start_transition("res://scene/rooms/menu.tscn", 1)
	pass


func _on_animation_player_animation_finished(anim_name):
	$music.play()
	
	var tween = get_tree().create_tween()
	$CanvasLayer/Textbox.show_text()
	pass # Replace with function body.


func _on_music_finished():
	SceneSwitcher.start_transition("res://scene/rooms/menu.tscn", 1)
	pass # Replace with function body.
