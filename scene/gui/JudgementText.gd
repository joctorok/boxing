extends Label
var horiSpeed : float
var vertiSpeed : float
var grv : float = 0.075

# Called when the node enters the scene tree for the first time.
func _ready():
	vertiSpeed = -2
	var tween3 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween3.tween_property(self, "theme_override_colors/font_color:a", 0, 2)
	var tween4 = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween4.tween_property(self, "theme_override_colors/font_outline_color:a", 0, 2)
	tween4.finished.connect(queue_free)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	horiSpeed = -0.5
	vertiSpeed += grv
	position.y += vertiSpeed
	position.x += horiSpeed
	pass
