extends Node2D

@onready var target := $target
@onready var marker := $marker
@onready var timer := $Timer
@onready var label := $Label
var inputPosition : float
var timeToTarget : float
var timeInMs : float
var tween
var canHit : bool

signal hit_uppercut(x, y)
signal hit_uc
signal miss_uc

func _ready():
	hide()

func _process(delta):
	if canHit == true:
		if Input.is_action_just_pressed("ui_accept") && timer.time_left != 0:
			inputPosition = timeToTarget - timer.time_left
			timeInMs = timeToTarget - inputPosition
			hit_uppercut.emit(inputPosition, timeToTarget - inputPosition)
			label.text = "time:" + str(snappedf(timer.time_left, 0.01))
			tween.kill()
			timer.stop()
			$time_to_hide.start(0.4)
			if $target.scale.x <= 1.05:
				emit_signal("hit_uc")
			else:
				emit_signal("miss_uc")
			canHit = false


func tween_marker():
	show()
	$time_to_hide.stop()
	timer.stop()
	label.text = "time:" + str(snappedf(timer.time_left, 0.01))
	canHit = true
	marker.scale = Vector2(3, 3)
	timer.start(timeToTarget)
	tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.tween_property(marker, "scale", Vector2(0.8,0.8), timeToTarget)	


func _on_time_to_hide_timeout():
	$time_to_hide.stop()
	canHit = false
	hide()
	pass # Replace with function body.


func _on_timer_timeout():
	timer.stop()
	emit_signal("miss_uc")
	canHit = false
	hide()
	pass # Replace with function body.
