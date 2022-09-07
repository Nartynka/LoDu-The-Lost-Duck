extends KinematicBody2D
class_name Player

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 100
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get('parameters/playback')
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var sprite = $Sprite

func _ready():
	var spawnpoints = get_tree().get_nodes_in_group("spawnpoints")
	for spawnpoint in spawnpoints:
		# if no previous spawnpoint found, spawn at any spawnpoint
		if not PlayerStats.spawnpoint:
			if spawnpoint:
				global_position = spawnpoint.global_position
		elif spawnpoint.name == PlayerStats.spawnpoint:
			global_position = spawnpoint.global_position
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	$Light2D.visible = !DayCycle.is_day
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		if input_vector.x != 0:
			sprite.scale.x = sign(input_vector.x)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel('Idle')
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	if Input.is_action_just_pressed("attack"):
		animationTree.set('parameters/Attack/blend_position', input_vector)
		state=ATTACK
	if Input.is_action_just_pressed("roll"):
		state=ROLL

func attack_state():
#	velocity = Vector2.ZERO
	animationState.travel('Attack')

func roll_state():
	velocity = roll_vector*ROLL_SPEED
	animationState.travel('Roll')
	move()

func move():
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state=MOVE

func roll_animation_finished():
	state=MOVE
	velocity = Vector2.ZERO

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
