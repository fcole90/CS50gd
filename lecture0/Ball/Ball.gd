extends Area2D
class_name Ball

export var speed = 500
onready var sprite: Sprite = $Sprite

var direction_angle = 0
var current_direction = Vector2.RIGHT

func set_random_direction():
	direction_angle = rand_range(deg2rad(-45), deg2rad(45))
	current_direction = Vector2(cos(direction_angle), sin(direction_angle))
	if randf() > 0.5:
		reflectX()

func get_rect() -> Rect2:
	var sprite_rect = sprite.get_rect()
	return Rect2(sprite_rect.position * sprite.scale + position, sprite_rect.size * sprite.scale)

func collides(rect: Rect2) -> bool:
	# first, check to see if the left edge of either is farther to the right
	# than the right edge of the other
	var ball_rect: Rect2 = get_rect()
	if ball_rect.position.x > rect.end.x or rect.position.x > ball_rect.end.x:
		return false
	# then check to see if the bottom edge of either is higher than the top
	# edge of the other
	if ball_rect.position.y > rect.end.y or rect.position.y > ball_rect.end.y:
		return false
	# if the above aren't true, they're overlapping
	return true

func move(direction: Vector2, delta: float):
	position += direction.normalized() * speed * delta

func setScale(x: int):
	sprite.scale = Vector2(x, x)

func reflectX():
	current_direction.x = -current_direction.x

func reflectY():
	current_direction.y = -current_direction.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	move(current_direction, delta)
