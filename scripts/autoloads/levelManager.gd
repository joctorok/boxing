extends Node

var currentLevel : String
const levelList = [
	"tutorial1",
	"round1",
	"tutorial2",
	"round2"
]
var levelIndex : int
var inTutorial : bool

func go_to_level(index):
	levelIndex = index
	currentLevel = levelList[levelIndex]
	if currentLevel == "tutorial2":
		inTutorial = true
	else:
		inTutorial = false
	SceneSwitcher.start_transition("res://scene/rooms/game.tscn", 0)
