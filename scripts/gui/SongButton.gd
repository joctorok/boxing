extends Node2D

@onready var songName : = $Control/HBoxContainer/SongStuff/SongName

@onready var click : = $Control/Button

var isSelected : bool

var tex : int

signal pressed

func _process(delta):
	match tex:
		0:
			$Control/HBoxContainer/SongStuff/SongName/Sprite2D.texture = load("res://sprites/rankIcons/badRankIcon.png")
		1:
			$Control/HBoxContainer/SongStuff/SongName/Sprite2D.texture = load("res://sprites/rankIcons/okRankIcon.png")
		2:
			$Control/HBoxContainer/SongStuff/SongName/Sprite2D.texture = load("res://sprites/rankIcons/boxinRankIcon.png")
		3:
			$Control/HBoxContainer/SongStuff/SongName/Sprite2D.texture = load("res://sprites/rankIcons/demoneyesRankIcon.png")
		4:
			$Control/HBoxContainer/SongStuff/SongName/Sprite2D.texture = null
	if isSelected:
		selected()
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("pressed")
	else:
		deselected()

#func _on_button_mouse_entered():
func selected():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Control, "position:y", 6, .25)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property($Control/ColorRect, "color", Color(Color(1, 1, 1, 1)), .25)
	pass # Replace with function body.


#func _on_button_mouse_exited():
func deselected():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Control, "position:y", 12, .25)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property($Control/ColorRect, "color", Color(Color(.5,.5,.5, 1)), .25)
	pass # Replace with function body.
