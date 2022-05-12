extends Area2D
class_name Paddle

export var speed = 50
onready var sprite: Sprite = $Sprite
onready var viewport: Rect2 = get_viewport_rect()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_rect() -> Rect2:
	var sprite_rect = sprite.get_rect()
	return Rect2(sprite_rect.position * sprite.scale + position, sprite_rect.size * sprite.scale)

func setScale(x: int):
	var xy_ratio = sprite.scale.y / sprite.scale.x
	sprite.scale = Vector2(x, x * xy_ratio)

func move(direction: Vector2, delta):
	var movement = direction.y * speed * delta
	if (
		# Allow only DOWN at top, only UP at bottom
		(get_rect().position.y > 0 or direction == Vector2.DOWN) and
		(get_rect().end.y < viewport.end.y or direction == Vector2.UP)
	):
		position.y += movement

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
