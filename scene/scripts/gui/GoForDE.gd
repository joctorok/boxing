extends HBoxContainer

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)

func Dim():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.5)

func ReturnOpacity():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)
