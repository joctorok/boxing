extends Sprite2D

@onready var aniPlayer : = $AnimationPlayer

@onready var sfxPunch : = $PunchSFX
@onready var sfxDodge : = $DodgeSFX
@onready var sfxHurt : = $HurtSFX
@onready var sfxUppercut : = $UppercutSFX

var ghost_scene = preload("res://scene/Ghost.tscn")

var inUppercut : bool
var canHit : bool
var sfxOffset : float = 0.028
var punchIndex : int = 1

var isDodging : bool

func _ready():
	z_index = 2
	PlayerAutoloads.healthPoints = PlayerAutoloads.maxHealthPoints
	aniPlayer.play("idle")

func _process(delta):
	if PlayerAutoloads.healthPoints < 0:
		PlayerAutoloads.healthPoints = 0
	if PlayerAutoloads.score < 0:
		PlayerAutoloads.score = 0
	calculate_timing_windows()
	player_handler()

func calculate_timing_windows():
	if ((get_parent().conductor.songPosition < 
	(get_parent().conductor.lastBeat + get_parent().conductor.crochet) + (get_parent().conductor.crochet/3)) and
	(get_parent().conductor.songPosition > (get_parent().conductor.lastBeat + get_parent().conductor.crochet) - 
	(get_parent().conductor.crochet/3))):
		canHit = true	
	else:
		canHit = false		

func player_handler():
	if (get_parent().cueIncoming and not inUppercut):
		#punch
		if (Input.is_action_just_pressed("ui_accept") and canHit):
			if get_parent().cueType == 1:
				player_punch()
			else:
				player_damage(2)
		elif (Input.is_action_just_pressed("ui_accept") and not canHit):
			player_damage(2)
		#dodge left
		if (Input.is_action_just_pressed("ui_left") and canHit):
			if get_parent().cueType == 2:
				player_dodge(-1)
			else:
				player_damage(2)
		elif (Input.is_action_just_pressed("ui_left") and !canHit):
			player_damage(2)
		#dodge right
		if (Input.is_action_just_pressed("ui_right") and canHit):
			if get_parent().cueType == 3:
				player_dodge(1)
			else:
				player_damage(2)
		elif (Input.is_action_just_pressed("ui_right") and !canHit):
			player_damage(2)

func player_punch():
	get_parent().cueIncoming = false
	punchIndex *= -1
	match punchIndex:
		-1:
			player_animator("punchL", sfxPunch)
		1:
			player_animator("punchR", sfxPunch)
	if PlayerAutoloads.healthPoints < PlayerAutoloads.maxHealthPoints:
		PlayerAutoloads.healthPoints += 2
	PlayerAutoloads.score += 20
	pass

func player_animator(animName, sfxIndex):
	aniPlayer.stop()
	sfxIndex.stop()
	aniPlayer.play(animName)
	sfxIndex.play(sfxOffset)
	pass

func player_dodge(dir : int):
	get_parent().cueIncoming = false
	match dir:
		-1:
			player_animator("dodgeL", sfxDodge)
		1:
			player_animator("dodgeR", sfxDodge)
	isDodging = true
	$DodgeTimer.stop()
	$DodgeTimer.start(0.6)
	$GhostTimer.start(0.02)
	if PlayerAutoloads.healthPoints < PlayerAutoloads.maxHealthPoints:
		PlayerAutoloads.healthPoints += 1
	PlayerAutoloads.score += 20
	pass

func player_uppercut():
	player_animator("uppercut", sfxUppercut)
	if PlayerAutoloads.healthPoints < PlayerAutoloads.maxHealthPoints:
		PlayerAutoloads.healthPoints += 4
	PlayerAutoloads.score += 40
	pass

func player_damage(damagePoints : int):
	get_parent().cueIncoming = false
	player_animator("damaged", sfxHurt)
	PlayerAutoloads.healthPoints -= 2
	PlayerAutoloads.score -= 40
	pass

func return_to_idle():
	$GhostTimer.stop()
	aniPlayer.play("idle")


func _on_dodge_timer_timeout():
	$GhostTimer.stop()
	isDodging = false
	$DodgeTimer.stop()
	pass # Replace with function body.

func ghost_instance():
	var ghost = ghost_scene.instantiate()
	ghost.z_index = 1
	get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = texture
	ghost.vframes = vframes
	ghost.hframes = hframes
	ghost.frame = frame

func _on_ghost_timer_timeout():
	ghost_instance()
	pass # Replace with function body.
