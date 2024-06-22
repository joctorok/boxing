extends Node

var currentLevel : String

const levelList = [
	"tutorial1",
	"round1",
	"round2"
]

const tutList = [
	"tutorial1",
	"tutorial2",
]

var levelIndex : int
var inTutorial : bool

func go_to_level(index):
	levelIndex = index
	currentLevel = levelList[levelIndex]
	SceneSwitcher.start_transition("res://scene/rooms/game.tscn", 0)
