extends Area2D

var active : bool
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active and Input.is_action_just_pressed("chart_place"):
		queue_free()
	pass


func _on_mouse_exited():
	active = false
	pass # Replace with function body.


func _on_mouse_entered():
	active = true
	pass # Replace with function body.
