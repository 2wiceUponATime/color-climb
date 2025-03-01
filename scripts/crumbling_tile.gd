extends StaticBody2D

var dissolving = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var respawn_timer: Timer = $RespawnTimer
const CRUMBLING = preload("res://scenes/tiles/crumbling.tscn")

func _ready() -> void:
	var process_material = particles.process_material
	if process_material is ParticleProcessMaterial:
		process_material.scale_min = global_scale.x
		process_material.scale_max = global_scale.x

func reset():
	var new_tile = CRUMBLING.instantiate()
	get_parent().add_child(new_tile)
	new_tile.position = position
	new_tile.rotation = rotation
	new_tile.scale = scale
	new_tile.skew = skew
	queue_free()

func _on_crumble_area_body_entered(_body: Node2D) -> void:
	if not dissolving:
		dissolving = true
		particles.emitting = true
		particles.position.y = 8
		sprite.play("destroy")
		$CrumbleSound.play()

func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.frame == 0 and respawn_timer.is_stopped():
		particles.emitting = false
		sprite.visible = false
		$CollisionShape2D.disabled = true
		respawn_timer.start()
		respawn_timer.timeout.connect(reset)
		return
	particles.position.y -= 2
