extends Sprite2D

func _ready():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)	
	tween.tween_property(self, "modulate:a", 0.0, 0.75)
	tween.finished.connect(on_tween_finished)

func on_tween_finished():
	queue_free()
