extends CharacterBody2D

const SPEED = 800.0
const JUMP_VELOCITY = -1200.0

var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_check_lava()

func _check_lava() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider is TileMapLayer:
			var hit_pos := collision.get_position() - collision.get_normal()
			var cell: Vector2i = collider.local_to_map(collider.to_local(hit_pos))
			var data: TileData = collider.get_cell_tile_data(cell)
			if data and data.get_custom_data("is_lava"):
				respawn()
				return

func respawn() -> void:
	global_position = start_position
	velocity = Vector2.ZERO
	
	move_and_slide()
