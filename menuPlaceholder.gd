extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.currentLevel = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tut_pressed():
	LevelManager.go_to_level(0)
	pass # Replace with function body.
