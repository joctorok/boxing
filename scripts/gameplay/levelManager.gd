extends Node

var currentLevel : String
const levelList = [
	"tutorial",
	"round1"
]
var levelIndex : int

func _process(delta):
	print(levelIndex)

func go_to_level(index):
	levelIndex = index
	currentLevel = levelList[levelIndex]
	SceneSwitcher.start_transition("res://scene/rooms/game.tscn")
