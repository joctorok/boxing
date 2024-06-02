extends AudioStreamPlayer2D
class_name Conductor

var bpm : float
var crochet : float
var songPosition : float
var offset : float = 0.028

var lastBeat : float = 0
var songPositionInBeats : float

@onready var ucTimer = $UppercutTimer

signal beatHit 
signal cueHit(x, y)
signal changeCamScale(x, y, z)
signal uppercutHit(x, y)
signal textDisplay(x, y)

@export var chart : String

func _ready():
	initSong()
	#pass

func _process(delta):
	songPosition = get_playback_position() + AudioServer.get_time_since_last_mix() 
	songPosition -= AudioServer.get_output_latency()
	songPositionInBeats = round(songPosition/crochet) + 1	
	beatProcess()
	#print(lastBeat)
	#pass

func beatProcess():
	var chartData = readJSON("res://songs/"+LevelManager.currentLevel+"/" + LevelManager.currentLevel+".json")
	if songPosition > lastBeat + crochet:
		for cue in chartData.song.cues_to_play:
			if (songPositionInBeats) == cue[1]:
				cueHit.emit(cue[0], cue[1])
		if "cam_control" in chartData.song:
			for camData in chartData.song.cam_control:
				if songPositionInBeats == camData[1]:
					changeCamScale.emit(camData[0], camData[1], camData[2])
		if "text" in chartData.song:
			for textData in chartData.song.text:
				if songPositionInBeats == textData[1]:
					textDisplay.emit(textData[0], textData[1])
		if "uppercuts" in chartData.song:
			for uppercutData in chartData.song.uppercuts:
				if songPositionInBeats == uppercutData[1]:
					uppercutHit.emit(uppercutData[0], uppercutData[1])
					ucTimer.start(uppercutData[0] * crochet)
		if ucTimer.time_left > 0:
			$Ping.play(0.028)
		emit_signal("beatHit")
		lastBeat += crochet

func readJSON(path : String):
	var json  = FileAccess.open(path, FileAccess.READ)
	return JSON.parse_string(json.get_as_text())

func initSong():
	var chartData = readJSON("res://songs/"+LevelManager.currentLevel+"/" + LevelManager.currentLevel+".json")
	var songAudio = "res://songs/"+LevelManager.currentLevel+"/" + LevelManager.currentLevel + ".ogg"
	stream = load(songAudio)
	bpm = chartData.song.bpm
	crochet = 60/bpm
	play()

func _on_uppercut_timer_timeout():
	$UppercutTimer.stop()
	pass # Replace with function body.
