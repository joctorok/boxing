extends Node

var currentLevel : String
const levelList = [
	"tutorial",
	"round1",
	"blocktut"
]
var levelIndex : int
var inStoryMode : bool

func go_to_level(index):
	levelIndex = index
	currentLevel = levelList[levelIndex]
	SceneSwitcher.start_transition("res://scene/rooms/game.tscn")
