extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CPUParticles2D.z_index = 3
	get_parent().get_parent().conductor.connect("beatHit", onBeatHit)
	onBeatHit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func onBeatHit():
	$CrowdFront.scale.y = 0.975
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($CrowdFront, "scale:y", 1, 0.25)
