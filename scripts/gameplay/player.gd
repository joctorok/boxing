extends Sprite2D

@onready var aniPlayer : = $AnimationPlayer

@onready var sfxPunch : = $PunchSFX
@onready var sfxDodge : = $DodgeSFX
@onready var sfxHurt : = $HurtSFX
@onready var sfxUppercut : = $UppercutSFX
@onready var sfxBlock : = $BlockSFX

@onready var dodgeTimer : = $DodgeTimer
@onready var ghostTimer : = $GhostTimer


var ghost_scene = preload("res://scene/objects/Ghost.tscn")

var inUppercut : bool
var canHit : bool
var sfxOffset : float = 0.028
var punchIndex : int = 1

var isDodging : bool

signal hit_cue(x)
signal miss_cue(x)

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
				hit_cue.emit(1)
			else:
				player_damage(2)
		elif (Input.is_action_just_pressed("ui_accept") and not canHit):
			player_damage(2)
		#dodge left
		if (Input.is_action_just_pressed("ui_left") and canHit):
			if get_parent().cueType == 2:
				player_dodge(-1)
				hit_cue.emit(2)
			else:
				player_damage(2)
		elif (Input.is_action_just_pressed("ui_left") and !canHit):
			player_damage(2)
		#dodge right
		if (Input.is_action_just_pressed("ui_right") and canHit):
			if get_parent().cueType == 3:
				player_dodge(1)
				hit_cue.emit(3)
			else:
				player_damage(2)
		if (Input.is_action_just_pressed("ui_down") and canHit):
			if get_parent().cueType == 4:
				player_block()
				hit_cue.emit(4)
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
		PlayerAutoloads.healthPoints += 1
	PlayerAutoloads.score += 20
	pass

func player_block():
	get_parent().cueIncoming = false
	player_animator("block", sfxBlock)
	if PlayerAutoloads.healthPoints < PlayerAutoloads.maxHealthPoints:
		PlayerAutoloads.healthPoints += 2
	PlayerAutoloads.score += 40
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
	dodgeTimer.stop()
	dodgeTimer.start(0.6)
	ghostTimer.start(0.02)
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
	PlayerAutoloads.healthPoints -= damagePoints
	PlayerAutoloads.score -= 40
	pass

func return_to_idle():
	ghostTimer.stop()
	aniPlayer.play("idle")


func _on_dodge_timer_timeout():
	ghostTimer.stop()
	isDodging = false
	dodgeTimer.stop()
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
