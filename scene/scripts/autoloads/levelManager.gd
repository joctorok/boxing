extends Node

var currentLevel : String

var levelIndex : int

var inTutorial : bool

#File Names of the levels that are allowed to be loaded into the song select menu
const levelList = [
	"tutorial1",
	"round1",
	"Test"
]

#Lits of tutorials that are allowed to be loaded
const tutList = [
	"tutorial1",
	"tutorial2",
]

#Accepts the Index argument and sends the selected Json to sceneSwitcher?
func go_to_level(index):
	levelIndex = index
	currentLevel = levelList[levelIndex]
	SceneSwitcher.start_transition("res://scene/rooms/game.tscn", 0)
