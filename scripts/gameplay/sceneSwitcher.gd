extends CanvasLayer


func start_transition(scene_to_switch_to : String):
	$AnimationPlayer.play("transition")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("transition2")
	get_tree().change_scene_to_file(scene_to_switch_to)	
