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
	pass

func Uppercut():
	inUppercut = false
	Animator("uppercut", sfxUppercut)
	if PlayerAutoloads.healthPoints < PlayerAutoloads.maxHealthPoints:
		PlayerAutoloads.healthPoints += 4
	PlayerAutoloads.score += 40
	pass

func Idle():
	ghostTimer.stop()
	aniPlayer.play("idle")


func _on_dodge_timer_timeout():
	ghostTimer.stop()
	isDodging = false
	dodgeTimer.stop()
	pass # Replace with function body.

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
	pass # Replace with function body.

func _on_results_play_anim():
	match PlayerAutoloads.curRank:
		PlayerAutoloads.Ranks.OKAY:
			Animator("damaged", sfxHurt)
		PlayerAutoloads.Ranks.DEMONEYES:
			Animator("block", sfxBlock)
	pass # Replace with function body.

func Hit(action : String, points : int, hpGain : float):
	get_parent().cueIncoming = false
	PlayerAutoloads.score += points
	PlayerAutoloads.healthPoints += hpGain
	match action:
		"Punch":
			Animator("punchL", sfxPunch)
			hit_cue.emit(1)
		"DodgeLeft":
			Animator("dodgeL", sfxDodge)
			hit_cue.emit(2)
			isDodging = true
			dodgeTimer.stop()
			dodgeTimer.start(0.6)
			ghostTimer.start(0.02)
		"DodgeRight":
			Animator("dodgeR", sfxDodge)
			hit_cue.emit(3)
			isDodging = true
			dodgeTimer.stop()
			dodgeTimer.start(0.6)
			ghostTimer.start(0.02)
		"Block":
			Animator("block", sfxBlock)
			hit_cue.emit(4)

func Damage(dmg : float, points : int):
	get_parent().cueIncoming = false
	Animator("damaged", sfxHurt)
	PlayerAutoloads.score -= points
	PlayerAutoloads.healthPoints -= dmg
