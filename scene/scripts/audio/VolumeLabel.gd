extends Node

var CurrentDisplayValue = 100
var TimeUntilhidden = 60
var HideTimer = 0

func _process(delta):
	if HideTimer < 100:
		print_debug(HideTimer)
		HideTimer += 1
		HideLable()

func ChangeLabel(x):
	if x:
		HideTimer = 0
		CurrentDisplayValue += 2
		ShowLabelAnim(true)
		
		
	else:
		HideTimer = 0
		CurrentDisplayValue -= 2
		ShowLabelAnim(true)
	
	get_node("Vol Label").text = str(CurrentDisplayValue)
	pass

func ShowLabelAnim(x):
	
	
	if x == true:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:x", 0, .25)
		
	pass

func HideLable():
	
	if HideTimer > TimeUntilhidden:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:x", -90, .25)
	
	pass

