extends Node2D

@onready var note : = $Note
@onready var noteBackdrop : = $NoteBackdrop

func _ready():
	note.hide()

func strum_tween(time, type):
	note.show()
	note.modulate.a = 0
	note.position.x = 152
	note.frame = type - 1
	var tween2 = get_tree().create_tween()
	tween2.tween_property(note, "modulate:a", 1, 0.15)
	var tween = get_tree().create_tween()
	tween.tween_property(note, "position:x", -16, time)
	tween.finished.connect(on_tween_finished)

func on_tween_finished():
	note.hide()
