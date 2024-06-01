extends Sprite2D

const botSprites = [
	"res://sprites/bots/kb_enemy.png",
	"res://sprites/bots/placeholder_bot.png"
]
@export var botIndex : int
@onready var aniPlayer : = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	aniPlayer.play("idle")
	texture = load(botSprites[botIndex])
	texture = load(botSprites[0])
	hframes = 7
	pass # Replace with function body.

func punch_player(direction : String):
	aniPlayer.stop()
	aniPlayer.play("punch"+direction)

func damage_self():
	aniPlayer.stop()
	aniPlayer.play("hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_animation_end():
	aniPlayer.play("idle")


func _on_player_miss_cue(x):
	match x:
		1, 2:
			punch_player("L")
		3, 4:
			punch_player("R")
	pass # Replace with function body.


func _on_player_hit_cue(x):
	match x:
		1:
			damage_self() 
		2:
			punch_player("L")
		3, 4:
			punch_player("R")		
	pass # Replace with function body.
