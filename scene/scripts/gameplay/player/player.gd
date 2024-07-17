extends Sprite2D

@onready var aniPlayer : = $AnimationPlayer

@onready var sfxPunch : = $PunchSFX
@onready var sfxDodge : = $DodgeSFX
@onready var sfxHurt : = $HurtSFX
@onready var sfxUppercut : = $UppercutSFX
@onready var sfxBlock : = $BlockSFX

@onready var dodgeTimer : = $DodgeTimer
@onready var ghostTimer : = $GhostTimer
@onready var cheerTimer : = $CheerTimer

var ghost_scene = preload("res://scene/objects/Ghost.tscn")

var inUppercut : bool
var canHit : bool
var sfxOffset : float = 0.028
var punchIndex : int = 1

var isDodging : bool

signal InputPress(x)
signal hit_cue(x)
signal miss_cue(x)

func _ready():
	z_index = 2
	PlayerAutoloads.healthPoints = PlayerAutoloads.maxHealthPoints
	aniPlayer.play("idle")

func _process(delta):
	inputHandle()
	if PlayerAutoloads.score < 0:
		PlayerAutoloads.score = 0

func inputHandle():
	if not inUppercut:
		if Input.is_action_just_pressed("ui_accept"):
			InputPress.emit(1)
		if Input.is_action_just_pressed("ui_left"):
			InputPress.emit(2)
		if Input.is_action_just_pressed("ui_right"):
			InputPress.emit(3)
		if Input.is_action_just_pressed("ui_down"):
			InputPress.emit(4)

func Animator(animName, sfxIndex):
	aniPlayer.stop()
	sfxIndex.stop()
	aniPlayer.play(animName)
	sfxIndex.play(sfxOffset)

func Uppercut():
	$Timer.start(0.05)
	Animator("uppercut", sfxUppercut)
	if PlayerAutoloads.healthPoints < PlayerAutoloads.maxHealthPoints:
		PlayerAutoloads.healthPoints += 4
	PlayerAutoloads.score += 40

func Idle():
	inUppercut = false
	ghostTimer.stop()
	aniPlayer.play("idle")

func _on_dodge_timer_timeout():
	ghostTimer.stop()
	isDodging = false
	dodgeTimer.stop()

func ghostInstance():
	var ghost = ghost_scene.instantiate()
	ghost.z_index = 1
	get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = texture
	ghost.vframes = vframes
	ghost.hframes = hframes
	ghost.frame = frame

func _on_ghost_timer_timeout():
	ghostInstance()

func _on_results_play_anim():
	match PlayerAutoloads.curRank:
		PlayerAutoloads.Ranks.OKAY:
			Animator("damaged", sfxHurt)
		PlayerAutoloads.Ranks.DEMONEYES:
			Animator("block", sfxBlock)

func Hit(action : int, points : int, hpGain : float):
	get_parent().cueIncoming = false
	PlayerAutoloads.score += points
	if PlayerAutoloads.healthPoints < PlayerAutoloads.maxHealthPoints:
		PlayerAutoloads.healthPoints += hpGain
	match action:
		1:
			punchIndex *= -1
			if punchIndex > 0:
				Animator("punchL", sfxPunch)
			else:
				Animator("punchR", sfxPunch)
			hit_cue.emit(1)
		2:
			Animator("dodgeL", sfxDodge)
			hit_cue.emit(2)
			isDodging = true
			dodgeTimer.stop()
			dodgeTimer.start(0.6)
			ghostTimer.start(0.02)
		3:
			Animator("dodgeR", sfxDodge)
			hit_cue.emit(3)
			isDodging = true
			dodgeTimer.stop()
			dodgeTimer.start(0.6)
			ghostTimer.start(0.02)
		4:
			Animator("block", sfxBlock)
			hit_cue.emit(4)

func Damage(dmg : float, points : int):
	get_parent().cueIncoming = false
	Animator("damaged", sfxHurt)
	if (get_parent().GUI.has_node("GoForDE")):
		get_parent().GUI.get_node("GoForDE").queue_free()
	PlayerAutoloads.score -= points
	PlayerAutoloads.missCount += 1
	PlayerAutoloads.healthPoints -= dmg

func _on_timer_timeout():
	$Timer.stop()
	inUppercut = false
	pass # Replace with function body.


func _on_cheer_timer_timeout():
	$CheerSFX.play()
	cheerTimer.stop()
	pass # Replace with function body.
