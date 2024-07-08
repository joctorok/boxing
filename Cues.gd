extends Node2D

func _process(delta):
	get_parent().get_node("ColorRect").position = floor(get_global_mouse_position()/32) * 32
	queue_redraw()

func _draw():
	for x in get_parent().cues:
		draw_rect(Rect2(x[0] * 32, x[1] * 32, 32.0, 32.0), Color.BLUE)
		
