# Top-down player controller

extends KinematicBody2D

var vel: Vector2
var facing: Vector2
var speed: float = 2.5

onready var anim: AnimationPlayer = $sprite_manager/animator

# Called when the node enters the scene tree for the first time.
func _ready():
	#anim.play("idle_down")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	vel = Vector2(0, 0)
	if Input.is_action_pressed("left"):
		vel.x = -speed
		facing = Vector2(-1, 0)
	elif Input.is_action_pressed("right"):
		vel.x = speed
		facing = Vector2(1, 0)
	if Input.is_action_pressed("up"):
		vel.y = -speed
		facing = Vector2(0, -1)
	elif Input.is_action_pressed("down"):
		vel.y = speed
		facing = Vector2(0, 1)
	
	if vel.x != 0.0 and vel.y != 0.0:
		vel = vel.normalized() * speed
	
	anim.playback_speed = vel.length()

func _physics_process(delta):
	vel = move_and_slide(vel * 60) / 60

func _on_intersect_area(area: Area2D) -> void:
	# entered an area2D
	pass

func _off_intersect_area(area: Area2D) -> void:
	# exited an area2D
	pass
