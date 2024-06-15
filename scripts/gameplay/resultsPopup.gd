extends CanvasLayer

signal rank_shown

signal play_anim

var canReturn : bool

func _ready():
	hide()
	
func start_ranking(amt):
	show()
	match PlayerAutoloads.curRank:
		PlayerAutoloads.Ranks.OKAY:
			$RankName.text = "OK."
		PlayerAutoloads.Ranks.BOXIN:
			$RankName.text = "Boxin"
		PlayerAutoloads.Ranks.DEMONEYES:
			$RankName.text = "Demon Eyes"
	$RankName.hide()
	start_bar(amt)

func _process(delta):
	if canReturn:
		if Input.is_action_just_pressed("ui_accept"):
			SceneSwitcher.start_transition("res://scene/rooms/menu.tscn", 0)
	$Label.text = str($HealthBar.value * 100) + "%"

func start_bar(amt):
	$DrumRoll.play()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($HealthBar, "value", amt, 5).set_ease(Tween.EASE_OUT)
	tween.finished.connect(finish_bar)

func _on_health_bar_value_changed(value):
	$Ping.play(0.028)
	pass # Replace with function body.

func finish_bar():
	emit_signal("play_anim")
	$DrumRoll.stop()
	$DrumHit.play()
	var rankTimer : Timer = Timer.new()
	add_child(rankTimer)
	rankTimer.one_shot = true
	rankTimer.autostart = false
	rankTimer.wait_time = 0
	rankTimer.start(0.75)
	rankTimer.timeout.connect(_on_rank_timer_timeout)

func _on_rank_timer_timeout():
	$Music.play()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Dim, "color", Color(Color(0, 0, 0, 0.5)), 0.85)
	$AnimationPlayer.play("ShowRank")
	return

func show_skip():
		canReturn = true
		var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween3.tween_property($Text, "theme_override_colors/font_color:a", 1, 0.50)
		var tween4 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween4.tween_property($Text, "theme_override_colors/font_outline_color:a", 1, 0.50)
