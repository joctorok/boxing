extends Node2D

var readRate : float = 0.05
@onready var label : = $Label

# Called when the node enters the scene tree for the first time

func _ready():
	$ColorRect.size.y = 0

func show_textbox():
	$BoxSFX.play(0.028)
	$ColorRect.size.y = 0
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($ColorRect, "size:y", 60, 0.25)

func show_text():
	show_textbox()
	$Label.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.tween_property($Label, "visible_ratio", 1, len($Label.text) * readRate)
	$Timer.stop()
	$Timer.start(readRate)

func hide_text():
	$Timer.stop()
	$Label.text = ""
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "size:y", 0, 0.25)

func _on_timer_timeout():
	if $Label.visible_ratio < 1:
		$TextSFX.play()
	else:
		$Timer.stop()
	pass # Replace with function body.
