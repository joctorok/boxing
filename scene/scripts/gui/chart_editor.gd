extends Node2D


var isActive : bool

var cues : Array

var placed : Array

var cueLoad = preload("res://ChartNote.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	isActive = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		$Cues.position.y -= 32
	if Input.is_action_just_pressed("ui_up"):
		$Cues.position.y += 32
	cues.sort_custom(sort_ascending)
	if isActive:
		if Input.is_action_just_pressed("chart_place"):
			if cues.has([(floor($Cues.get_local_mouse_position().x/32)), (floor($Cues.get_local_mouse_position().y/32))]):
				cues.erase([(floor($Cues.get_local_mouse_position().x/32)), (floor($Cues.get_local_mouse_position().y/32))])
			else:
				cues.append([(floor($Cues.get_local_mouse_position().x/32)), (floor($Cues.get_local_mouse_position().y/32))])
	print(cues)
	if $Cues.position.y > 32:
		$Cues.position.y = 32
	pass




func _on_active_area_mouse_exited():
#	isActive = false
	pass # Replace with function body.
func _on_active_area_mouse_entered():
#	isActive = true
	pass # Replace with function body.

func sort_ascending(a, b):
	if a[1] < b[1]:
		return true
	return false
