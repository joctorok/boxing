extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("player_death")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		LevelManager.go_to_level(LevelManager.levelIndex)
	if Input.is_action_just_pressed("ui_cancel"):
		SceneSwitcher.start_transition("res://scene/rooms/menu.tscn")
	pass


func _on_animation_player_animation_finished(anim_name):
	$music.play()
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/Label, "visible_ratio", 1, (0.05 * len($CanvasLayer/Label.text)))	 
	pass # Replace with function body.


func _on_music_finished():
	SceneSwitcher.start_transition("res://scene/rooms/menu.tscn")
	pass # Replace with function body.
