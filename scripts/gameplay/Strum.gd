extends Node2D

@onready var note : = $Note
@onready var noteBackdrop : = $NoteBackdrop

func _ready():
	note.hide()

func strum_tween(time, type):
	note.show()
	note.position.x = 152
	note.frame = type - 1
	var tween = get_tree().create_tween()
	tween.tween_property(note, "position:x", -16, time)
	tween.finished.connect(on_tween_finished)

func on_tween_finished():
	note.hide()
