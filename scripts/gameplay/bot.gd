extends Sprite2D

const botSprites = [
	"res://scripts/sprites/bots/kb_enemy.png",
	"res://scripts/sprites/bots/placeholder_bot.png"
]
@export var botIndex : int
@onready var aniPlayer : = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	aniPlayer.play("idle")
	texture = load(botSprites[botIndex])
	match LevelManager.levelIndex:
		0:
			texture = load(botSprites[1])
			hframes = 2
		1:
			texture = load(botSprites[0])
			hframes = 7
	pass # Replace with function body.

func punch_player(direction : String):
	aniPlayer.play("punch"+direction)

func damage_self():
	aniPlayer.play("hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_animation_end():
	aniPlayer.play("idle")


func _on_player_miss_cue(x):
	match x:
		1, 2:
			punch_player("L")
		3:
			punch_player("R")
	pass # Replace with function body.


func _on_player_hit_cue(x):
	match x:
		1:
			damage_self() 
		2:
			punch_player("L")
		3:
			punch_player("R")		
	pass # Replace with function body.
