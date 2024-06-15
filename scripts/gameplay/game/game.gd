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

@onready var cueHai : = $Cues/Hai
@onready var cueLeft : = $Cues/Left
@onready var cueParry : = $Cues/Parry

@onready var cueRight : = $Cues/Right

var current_bot : String

@onready var dim : = $GUI/ColorRect
@onready var flash : = $GUI/Flash

var canSkip : bool

func _ready():
	PlayerAutoloads.curAccuracy = 1
	PlayerAutoloads.missCount = 0
	canSkip = false
	if LevelManager.inTutorial:
		var timeToSkip = Timer.new()
		add_child(timeToSkip)
		timeToSkip.one_shot = true
		timeToSkip.autostart = false
		timeToSkip.wait_time = 0
		timeToSkip.timeout.connect(_on_skip_timer_timeout)
		timeToSkip.start(conductor.crochet)
	var chartData = readJSON("res://songs/"+LevelManager.currentLevel+"/" + LevelManager.currentLevel+".json")
	if chartData.song.has("artist"):
		$GUI/SongName.text = "Song: " + chartData.song.name + "\n" + "by " + chartData.song.artist
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property($GUI/SongName, "position:x", 5, 0.5).set_ease(Tween.EASE_OUT)
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.autostart = false
		timer.wait_time = 0
		timer.timeout.connect(_hide_song_info)
		timer.start(5)
	var cues : Array = chartData.song.cues_to_play
	var uc : Array = chartData.song.uppercuts
	PlayerAutoloads.maxMisses = len(cues) + len(uc)
	print(PlayerAutoloads.maxMisses)
	bot.texture = load("res://sprites/characters/"+chartData.song.enemy+".png")
	var s = load("res://scene/stages/"+chartData.song.stage+".tscn")
	var stage = s.instantiate()
	$Stage.add_child(stage)
	PlayerAutoloads.score = 0
	cueIncoming = false

func _process(delta):
	$GUI/Score.text = "Score: " + str(PlayerAutoloads.score)
	if Input.is_action_just_pressed("gm_quit"):
		conductor.stop()
		SceneSwitcher.start_transition("res://scene/rooms/menu.tscn", 0)
	if canSkip && Input.is_action_just_pressed('gm_skip'):
		LevelManager.go_to_level(LevelManager.levelIndex + 1)
	pass

func _on_conductor_cue_hit(x, y):
	cueIncoming = true
	cueType = x
	curCueTime = y
	match cueType:
		1:
			cueHai.play()
		2:
			cueLeft.play()
		3:
			cueRight.play()
		4:
			cueParry.play()
			var blockTimer : Timer = Timer.new()
			add_child(blockTimer)
			blockTimer.one_shot = true
			blockTimer.autostart = false
			blockTimer.wait_time = 0
			blockTimer.start(conductor.crochet)
			blockTimer.timeout.connect(_on_block_timer_timeout)
	var cueTimer : Timer = Timer.new()
	add_child(cueTimer)
	cueTimer.one_shot = true
	cueTimer.autostart = false
	cueTimer.wait_time = 0
	cueTimer.timeout.connect(_on_cue_timer_timeout)
	cueTimer.start(conductor.crochet + 0.10)
	
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
	uppercut_create(x*conductor.crochet)
	pass # Replace with function body.

func uppercut_create(x):
	uppercutHandler.timeToTarget = x
	uppercutHandler.tween_marker()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween.tween_property(cam, "zoom", Vector2(1.5, 1.5), 0.75)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween2.tween_property(dim, "color", Color(Color(0, 0, 0, 0.5)), 0.75)

func _on_uppercut_handler_hit_uc(): 
	flash.color = Color(1, 1, 1, 1)
	player.player_uppercut()
	bot.aniPlayer.play("hit")
	player.inUppercut = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween3.tween_property(flash, "color", Color(1, 1, 1, 0), 0.75)
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

func _on_block_timer_timeout():
	player.inUppercut = true
	conductor.ucTimer.start(3 * conductor.crochet)
	uppercut_create(3 * conductor.crochet)

func _on_skip_timer_timeout():
	canSkip = true
	$GUI/SkipText.text = "Press SHIFT to skip tutorial."
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($GUI/SkipText, "theme_override_colors/font_color:a", 1, 0.50)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween2.tween_property($GUI/SkipText, "theme_override_colors/font_outline_color:a", 1, 0.50)
	
func _on_conductor_finished():
	#if not LevelManager.inTutorial:
		calculateRating()
		$GUI/HealthBar.hide()
		$GUI/Score.hide()
		textbox.hide()
		$GUI/Results.start_ranking(PlayerAutoloads.curAccuracy)
		$GUI/SkipText.hide()
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
		tween.tween_property(cam, "zoom", Vector2(1.5, 1.5), 0.75)
#	else:
		#LevelManager.go_to_level(LevelManager.levelIndex + 1)
#	pass # Replace with function body.

func readJSON(path : String):
	var json  = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(json.get_as_text())

func calculateRating():
	PlayerAutoloads.curAccuracy = 1 - PlayerAutoloads.missCount/PlayerAutoloads.maxMisses
	if PlayerAutoloads.curAccuracy == 1:
		PlayerAutoloads.curRank = PlayerAutoloads
	elif PlayerAutoloads.curAccuracy >= 0.50:
		PlayerAutoloads.curRating = "Boxin'!"
	else:
		PlayerAutoloads.curRating = "OK."
	print(PlayerAutoloads.curRating)
	
func _hide_song_info():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($GUI/SongName, "position:x", -40, 0.5).set_ease(Tween.EASE_IN)
	await tween.finished
	$GUI/SongName.hide()

func _on_timer_timeout():
	if PlayerAutoloads.curRank == PlayerAutoloads.Ranks.DEMONEYES:
		flash.color = Color(1, 1, 1, 1)
		var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
		tween3.tween_property(flash, "color", Color(1, 1, 1, 0), 0.75)
