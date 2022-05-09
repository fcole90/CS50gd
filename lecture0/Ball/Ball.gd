extends Area2D
class_name Ball

export var speed = 10
onready var sprite: Sprite = $Sprite
onready var viewport: Rect2 = get_viewport_rect()

var direction_angle = rand_range(0, 1) #deg2rad(180 - 22)
var current_direction = Vector2(cos(direction_angle), sin(direction_angle))

func set_random_direction():
	direction_angle = rand_range(0, 1) #deg2rad(180 - 22)
	current_direction = Vector2(cos(direction_angle), sin(direction_angle))


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
	position += direction * speed * delta

func setScale(x: int):
	sprite.scale = Vector2(x, x)

func reflectX():
	current_direction.x = -current_direction.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Reflect horizontally
#	if (position.x <= 0 or position.x >= viewport.size.x):
#		reflectX()
	# Reflect vertically
	if (position.y <= 0 or position.y >= viewport.size.y):
		current_direction.y = -current_direction.y
	move(current_direction, delta)
