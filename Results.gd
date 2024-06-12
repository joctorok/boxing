extends Node2D

var readRate : float = 0.05
# Called when the node enters the scene tree for the first time.
func _ready():
	$Percentage.text = str(floor(PlayerAutoloads.curAccuracy * 100)) + "%"
	
	$Percentage.visible_ratio = 0
	$Label.visible_ratio = 0
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($RatingScreen, "position:y", 72, 0.75)
	match PlayerAutoloads.curRating:
		"okay":
			$RatingScreen.texture = load("res://sprites/results/okayRating.png")
			$Label.text = "Well... at least you move onto the next round, kid."
		"boxin":
			$RatingScreen.texture = load("res://sprites/results/boxinRating.png")
			$Label.text = "That's what I'm talkin about! Show it what it really means to be a champ, kid!"
		"demon_eyes":
			$RatingScreen.texture = load("res://sprites/results/demoneyesRating.png")
			$Label.text = "That's the son of Demon Eyes Spring for ya... Never ceases to amaze me..."
	text_show()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		SceneSwitcher.start_transition("res://scene/rooms/menu.tscn", 0)
	pass

func text_show():
	var tween = get_tree().create_tween()
	tween.tween_property($Label, "visible_ratio", 1, len($Label.text) * readRate)
	$Timer.stop()
	$Timer.start(readRate)

func _on_timer_timeout():
	if $Label.visible_ratio < 1:
		$Sfx.play()
	else:
		$TimeToShowResults.start(0.25)
		$Timer.stop()
	pass # Replace with function body.

func showResults():
	$Percentage.visible_ratio = 1
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Dim, "color", Color(Color(0, 0, 0, 0.5)), 0.85)
	$AnimationPlayer.play("ShowResults")

func _on_time_to_show_results_timeout():
	$TimeToShowResults.stop()
	showResults()
	pass # Replace with function body.
