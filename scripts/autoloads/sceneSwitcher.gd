extends CanvasLayer


func start_transition(scene_to_switch_to : String, type : int):
	match type:
		0:
			$AnimationPlayer.play("transition")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play("transition2")
			get_tree().change_scene_to_file(scene_to_switch_to)	
		1:
			$AnimationPlayer.play("transition3")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play_backwards("transition3")
			get_tree().change_scene_to_file(scene_to_switch_to)	
