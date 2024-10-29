extends Area2D

signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_vector = Vector2.ZERO 
	if(Input.is_action_pressed("move_right")):
		movement_vector.x += 1
	if(Input.is_action_pressed("move_left")):
		movement_vector.x -= 1
	if(Input.is_action_pressed("move_up")):
		movement_vector.y -= 1
	if(Input.is_action_pressed("move_down")):
		movement_vector.y += 1
	
	if (movement_vector.length() > 0):
		movement_vector = movement_vector.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += movement_vector * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if(movement_vector.x != 0):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = movement_vector.x < 0
	elif movement_vector.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = movement_vector.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func reStart(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
