# Side-scrolling platformer player controller

extends KinematicBody2D

export(float) var maxfall: float = 16.0
export(float) var movespeed: float = 8.0
export(float) var gravity: float = 0.35
export(float) var jumpvel: float = 6
export(float) var fixrate: float = 1.0

onready var sprite: AnimatedSprite = $sprite
onready var maxy: float = $"/root/scene/world_bottom".position.y;

onready var initpos: Vector2 = position
var vel: Vector2 = Vector2(0, 0)
var pvel: Vector2
var jumps: int = 0
var on_one_way: bool
var landed: bool
var stepped: bool
var dead := false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# Control animation
	if abs(vel.y) < 0.1:
		if sprite.animation != "run":
			sprite.animation = "run"
		sprite.speed_scale = abs(vel.x / 3)
		if vel.x == 0:
			sprite.frame = 0
		if sprite.frame == 1 and not stepped:
			stepped = true
		elif sprite.frame != 1:
			stepped = false
	elif vel.y > 0.1:
		sprite.animation = "fall"
	if abs(vel.x) > 0:
		sprite.flip_h = vel.x < 0
	if abs(vel.x) > 0.1 and vel.y == 0.0:
		Sounds.unpause("run", position)
	else:
		Sounds.pause("run", position)
	
	# World boundary
	if position.y > maxy:
		death()

func _physics_process(_delta: float) -> void:

	# Move left and right
	if Input.is_action_pressed("right"):
		vel.x = movespeed
	elif Input.is_action_pressed("left"):
		vel.x = -movespeed
	else:
		vel.x = 0
	
	# Set velocity to zero on ground
	if is_on_floor():
		if pvel.y > gravity + 0.1:
			Sounds.play("hit1", position)
		vel.y = 0
		jumps = 2
	else:
		vel.y += gravity
	
	# Jump
	if Input.is_action_just_pressed("jump") and jumps > 0:
		vel.y = -jumpvel
		jumps -= 1
		sprite.speed_scale = 1
		sprite.play("jump")
		if jumps == 1:
			Sounds.play("jump1", position)
		else:
			Sounds.play("jump2", position)
	
	# Terminal velocity
	vel.y = min(vel.y, maxfall)

	# Fall through one-way platforms
	if Input.is_action_just_pressed("fall"):
		position.y += 2
		if vel.y != 0:
			vel.y = 6
	
	# Collision
	pvel = vel
	vel = move_and_slide(vel * 60, Vector2(0, -1)) / 60
	for i in get_slide_count():
		var col = get_slide_collision(i)
		if col.collider is TileMap:
			var t: TileMap = col.collider
			var p = t.world_to_map(col.position)
			var c = t.get_cell_autotile_coord(p.x, p.y)
			if t.tile_set.is_damage_tile(c):
				death()

func death():
	dead = true
	Sounds.play("die", position)
	hide()
	Global.game.player_died()
