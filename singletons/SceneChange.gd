extends CanvasLayer

onready var animation = $AnimationPlayer
onready var rect = $Control/ColorRect

func fade_in():
	animation.playback_speed = 0.5
	animation.play_backwards("fade")

func change_scene(scene:String, speed:int = 2):
	animation.playback_speed = speed
	animation.play("fade")
	yield(animation, "animation_finished")
	assert(get_tree().change_scene(scene) == OK)
	animation.play_backwards("fade")
