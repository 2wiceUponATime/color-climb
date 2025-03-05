class_name Player extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic
var fading_out = false
var spawnpoint: Vector2

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	position = $"../Spawnpoint".position
	spawnpoint = position
	$MultiplayerSynchronizer.set_multiplayer_authority(name.to_int())
	var data = Save.data
	if data.size():
		spawnpoint = Vector2(data["spawnpoint_x"], data["spawnpoint_y"])
		position = spawnpoint
	if not Global.is_authority(self):
		$Camera2D.queue_free()
		$Light.queue_free()
	
func apply_gravity(delta: float) -> void:
	if position.y > -1000:
		velocity += get_gravity() * delta
	else:
		velocity.y = -100
		fade_out()

func fade_out() -> void:
	if fading_out:
		return
	fading_out = true
	var tween = get_tree().create_tween()
	var clear_color = RenderingServer.get_default_clear_color()
	sprite.speed_scale = 0
	tween.tween_property($"../../FadeOut", "color", Color.BLACK, 3)
	tween.parallel().tween_method(
		RenderingServer.set_default_clear_color,
		clear_color,
		Color.BLACK,
		3
	)
	tween.parallel().tween_property(background_music, "volume_db", -50, 3)
	await tween.finished
	RenderingServer.set_default_clear_color(clear_color)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _physics_process(delta: float) -> void:
	if not Global.is_authority(self):
		return
	var debug = OS.is_debug_build() and Input.is_action_pressed("debug")
	collision_shape.disabled = debug
	if debug:
		debug_physics_process()
		return
	
	if not $KillTimer.is_stopped():
		sprite.play("death")
		apply_gravity(delta)
		move_and_slide()
		return
	
	var on_floor = is_on_floor()
	if on_floor:
		$JumpTimer.start()
	else:
		apply_gravity(delta)

	if Input.is_action_pressed("jump") and not $JumpTimer.is_stopped():
		velocity.y = JUMP_VELOCITY
		$JumpTimer.stop()
		$JumpSound.play()

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if on_floor:
			sprite.play("run")
		else:
			sprite.play("jump")
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")

	var fall_speed = velocity.y
	move_and_slide()
	if is_on_floor() and fall_speed > 600:
		kill()
	if position.y > 300 or Input.is_action_just_pressed("kill"):
		kill()

func debug_physics_process():
	var speed = SPEED * 2
	var direction_x := Input.get_axis("left", "right")
	if direction_x:
		velocity.x = direction_x * speed
		sprite.play("run")
		sprite.flip_h = direction_x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		sprite.play("idle")
	
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * speed
		sprite.play("run")
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()

func save():
	Save.data["spawnpoint_x"] = spawnpoint.x
	Save.data["spawnpoint_y"] = spawnpoint.y

func kill():
	if not $KillTimer.is_stopped():
		return
	Engine.time_scale = 0.4
	velocity.x /= 4
	$KillTimer.start()
	$DeathSound.play()

func _on_kill_timer_timeout() -> void:
	position = spawnpoint
	velocity = Vector2.ZERO
	Engine.time_scale = 1
	sprite.speed_scale = 1
