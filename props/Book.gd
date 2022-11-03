extends StaticBody2D

onready var animationPlayer = $AnimationPlayer

var active := false

func _on_InteractionArea_body_entered(body):
	if body is Player:
		active = true

func _on_InteractionArea_body_exited(body):
	if body is Player:
		active = false

func _input(event):
	if Input.is_action_just_pressed("action") and active:
		animationPlayer.play("Open")
