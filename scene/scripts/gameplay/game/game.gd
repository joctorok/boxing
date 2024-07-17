extends Node2D

var cueIncoming : bool
var cueType : int
var curCueTime : float
var safeZone : float



var judgementText = preload("res://scene/gui/JudgementText.tscn")
var goForDE = preload("res://scene/gui/GoForDE.tscn")
var resultsScreen = preload("res://scene/gui/resultsPopup.tscn")

@onready var GUI = $GUI

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

var noteRatings = ["Early!", "Just Right!", "Late.."]

var canHit : bool
var canSkip : bool
var canExit : bool

var highestRank : int

func _ready():
	if FileAccess.file_exists("user://" + LevelManager.currentLevel + ".json"):
		var save = readJSON("user://" + LevelManager.currentLevel + ".json")
		highestRank = save.data.rank
	if highestRank < PlayerAutoloads.Ranks.DEMONEYES:
		var DE = goForDE.instantiate()
		GUI.add_child(DE)
	canExit = true 
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
	safeZone = conductor.crochet/2
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
	if PlayerAutoloads.healthPoints <= 0:
		get_tree().change_scene_to_file("res://scene/rooms/gameover.tscn")
	if Input.is_action_just_pressed("gm_quit") && canExit:
		canExit = false
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		CamChange(Vector2(0.85, 0.85))
		tween.tween_property(conductor, "pitch_scale", 0.5, 0.75)
		tween.finished.connect(go_to_menu)
	if canSkip && Input.is_action_just_pressed('gm_skip'):
		LevelManager.go_to_level(LevelManager.levelIndex + 1)
	pass

func _on_conductor_cue_hit(x, y):
	cueIncoming = true
	cueType = x 
	curCueTime = (y) * conductor.crochet
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
	cueTimer.start(conductor.crochet + 0.16)
	pass # Replace with function body.

func _on_cue_timer_timeout():
	if cueIncoming == true:
		player.Damage(2, 10)
		player.miss_cue.emit(cueType)
		cueIncoming = false

func _on_conductor_change_cam_scale(x, y, z):
	$Player/RemoteTransform2D.update_position = z
	CamChange(Vector2(x,x))
	pass # Replace with function body.

func _on_conductor_uppercut_hit(x, y):
	player.inUppercut = true
	uppercut_create(x*conductor.crochet)
	pass # Replace with function body.

func uppercut_create(x):
	uppercutHandler.timeToTarget = x
	uppercutHandler.tween_marker()
	CamChange(Vector2(1.5,1.5))
	Dim(Color(Color(0, 0, 0, 0.5)))

func _on_uppercut_handler_hit_uc(): 
	player.Uppercut()
	player.cheerTimer.start(conductor.crochet)
	bot.damage_self()
	Flash()
	Dim(Color(Color(0, 0, 0, 0)))
	CamChange(Vector2(1,1))
	pass # Replace with function body.

func _on_uppercut_handler_miss_uc():
	player.Damage(4, 20)
	bot.punch_player("L")
	CamChange(Vector2(1,1))
	Dim(Color(Color(0, 0, 0, 0)))
	pass # Replace with function body.

func CamChange(scale : Vector2):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween.tween_property(cam, "zoom", scale, 0.75)
	

func Dim(color : Color):
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween2.tween_property(dim, "color", color, 0.75)

func Flash():
	flash.color = Color(1, 1, 1, 1)
	var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween3.tween_property(flash, "color", Color(1, 1, 1, 0), 0.75)

func _on_conductor_text_display(x, y):
	textbox.label.text = x
	textbox.show_text()
	if (GUI.has_node("GoForDE")):
		GUI.get_node("GoForDE").Dim()
	if x == "":
		textbox.hide_text()
		if (GUI.has_node("GoForDE")):
			GUI.get_node("GoForDE").ReturnOpacity()
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
		saveScore()
		GUI.hide()
		var results = resultsScreen.instantiate()
		add_child(results)
		results.start_ranking(PlayerAutoloads.curAccuracy)
		CamChange(Vector2(1.5, 1.5))
#	else:
		#LevelManager.go_to_level(LevelManager.levelIndex + 1)
#	pass # Replace with function body.

func saveScore():
	if PlayerAutoloads.curRank > highestRank:
		var filePath : String = "user://" + LevelManager.currentLevel + ".json"
		var save = FileAccess.open(filePath, FileAccess.WRITE)
		var dict = {
			"data" : {"score" : PlayerAutoloads.score,
			"rank" : PlayerAutoloads.curRank}
		}
		var string = JSON.stringify(dict)
		save.store_string(string)
		save.close()
	return

func readJSON(path : String):
	var json  = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(json.get_as_text())

func _hide_song_info():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($GUI/SongName, "position:x", -40, 0.5).set_ease(Tween.EASE_IN)
	await tween.finished
	$GUI/SongName.hide()

func _on_timer_timeout():
	if PlayerAutoloads.curRank == PlayerAutoloads.Ranks.DEMONEYES:
		Flash()

func go_to_menu():
		SceneSwitcher.start_transition("res://scene/rooms/SongSelect.tscn", 1)

func _on_player_input_press(x):
	if player.inUppercut == false and cueIncoming:
		cueIncoming = false
		var dist = (conductor.songPosition - curCueTime)
		if abs(dist) <= safeZone:
			if cueType == x:
				var curNoteRating : String
				var scoreIncrement : float
				var hpIncrement : float
				if abs(dist) > safeZone/4:
					scoreIncrement = 10
					hpIncrement = 0
					if dist > 0:
						curNoteRating = noteRatings[2]
					else:
						curNoteRating = noteRatings[0]
				else:
					scoreIncrement = 20
					hpIncrement = 2
					curNoteRating = noteRatings[1]
				player.Hit(x, scoreIncrement, hpIncrement)
				var i = judgementText.instantiate()
				GUI.add_child(i)
				i.text = curNoteRating + " +" + str(scoreIncrement)
				print(curNoteRating)
			else:
				var i = judgementText.instantiate()
				GUI.add_child(i)
				i.text = "Ouch..."
				player.Damage(2, 10)
		else:
			if dist > 0:
				var i = judgementText.instantiate()
				GUI.add_child(i)
				i.text = "Too Late..."
			else:
				var i = judgementText.instantiate()
				GUI.add_child(i)
				i.text = "Too Early..."
			player.Damage(2, 10)
