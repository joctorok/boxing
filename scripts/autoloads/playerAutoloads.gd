extends Node

var healthPoints : float
var maxHealthPoints : float = 20
var score : float
var missCount : float
var maxMisses : float
var curRating : String

enum Ranks {
	TRYAGAIN,
	OKAY,
	BOXIN,
	DEMONEYES
}
var curAccuracy : float
var curRank

func _process(delta):
	print(curRank)
	curAccuracy = 1 - (missCount/maxMisses)
	if curAccuracy == 1:
		curRank = Ranks.DEMONEYES
	elif curAccuracy >= 0.75:
		curRank = Ranks.BOXIN
	else:
		curRank = Ranks.OKAY
