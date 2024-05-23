extends Node2D

var cueIncoming : bool
var cueType : int
var curCueTime : float

@onready var player : = $Player
@onready var conductor : = $Conductor
@onready var cam : = $Camera2D
@onready var uppercutHandler : = $GUI/UppercutHandler
@onready var bot : = $Bot
@onready var textbox : = $GUI/Textbox
@onready var strum : = $GUI/Strum


@onready var dim : = $GUI/ColorRect

func _ready():
	PlayerAutoloads.score = 0
	cueIncoming = false

func _process(delta):
	$GUI/Score.text = "Score: " + str(PlayerAutoloads.score)
	if Input.is_action_just_pressed("gm_quit"):
		conductor.stop()
		SceneSwitcher.start_transition("res://scene/rooms/menu.tscn")
	if PlayerAutoloads.healthPoints < 0:
		get_tree().change_scene_to_file("res://scene/rooms/gameover.tscn")
	pass

func _on_conductor_cue_hit(x, y):
	cueIncoming = true
	cueType = x
	curCueTime = y
	strum.strum_tween(conductor.crochet + conductor.crochet/3, x)
	var cueTimer : Timer = Timer.new()
	add_child(cueTimer)
	cueTimer.one_shot = true
	cueTimer.autostart = false
	cueTimer.wait_time = 0
	cueTimer.timeout.connect(_on_cue_timer_timeout)
	cueTimer.start(conductor.crochet + (conductor.crochet/3))
	
	pass # Replace with function body.

func _on_cue_timer_timeout():
	if cueIncoming == true:
		player.player_damage(2)
		player.miss_cue.emit(cueType)
		cueIncoming = false

func _on_conductor_change_cam_scale(x, y, z):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(cam, "zoom", Vector2(x, x), 0.75)
	$Player/RemoteTransform2D.update_position = z
	pass # Replace with function body.


func _on_conductor_uppercut_hit(x, y):
	player.inUppercut = true
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween.tween_property(cam, "zoom", Vector2(1.5, 1.5), 0.75)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween2.tween_property(dim, "color", Color(Color(0, 0, 0, 0.5)), 0.75)
	uppercut_create(x*conductor.crochet)
	pass # Replace with function body.

func uppercut_create(x):
	uppercutHandler.timeToTarget = x
	uppercutHandler.tween_marker()

func _on_uppercut_handler_hit_uc(): 
	player.player_uppercut()
	bot.aniPlayer.play("hit")
	player.inUppercut = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween2.tween_property(dim, "color", Color(Color(0, 0, 0, 0)), 0.75)
	tween.tween_property(cam, "zoom", Vector2(1, 1), 0.75)
	pass # Replace with function body.


func _on_uppercut_handler_miss_uc():
	player.player_damage(4)
	bot.punch_player("L")
	player.inUppercut = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween.tween_property(cam, "zoom", Vector2(1, 1), 0.75)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween2.tween_property(dim, "color", Color(Color(0, 0, 0, 0)), 0.75)
	pass # Replace with function body.


func _on_conductor_text_display(x, y):
	textbox.label.text = x
	textbox.show_text()
	if x == "":
		textbox.hide_text()
	pass # Replace with function body.


func _on_conductor_finished():
	if LevelManager.levelIndex == (len(LevelManager.levelList) - 1):
		SceneSwitcher.start_transition("res://scene/rooms/menu.tscn")
	else:
		LevelManager.levelIndex += 1
		LevelManager.go_to_level(LevelManager.levelIndex)
	pass # Replace with function body.
