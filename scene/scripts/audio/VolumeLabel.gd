extends Node

var CurrentDisplayValue

func ChangeLabel(x):
	CurrentDisplayValue = lerp(x, 0.0, 10.0)
	get_node("Vol Label").text = str(CurrentDisplayValue)
	pass
