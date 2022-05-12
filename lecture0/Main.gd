"""
GD50 2018 - Lecture 0
Pong Remake for Godot
---------------------
Author: Fabio Colella
fcole90@gmail.com
Godot/GD Script port of the original Lua version

Original code: https://github.com/cs50/gd50/tree/master/pong
Original Author: Colton Ogden
cogden@cs50.harvard.edu
Originally programmed by Atari in 1972. Features two
paddles, controlled by players, with the goal of getting
the ball past your opponent's edge. First to 10 points wins.
This version is built to more closely resemble the NES than
the original Pong machines or the Atari 2600 in terms of
resolution, though in widescreen (16:9) so it looks nicer on
modern systems.
"""
extends Node2D

# Size we're trying to emulate
const VIRTUAL_SIZE = Vector2(109,61)
onready var viewport_size: Vector2 = get_viewport_rect().size
onready var tiles_size: Vector2 = viewport_size / VIRTUAL_SIZE
onready var ball: Ball = $Ball
onready var left_paddle: Paddle = $LeftPaddle
onready var right_paddle: Paddle = $RightPaddle
onready var paddle_sound: AudioStreamPlayer = $PaddleSound
onready var score_sound: AudioStreamPlayer = $ScoreSound
onready var wall_hit_sound: AudioStreamPlayer = $WallHitSound

var ball_color = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set correct sizes based on our virtual size
	ball.setScale(tiles_size.x)
	left_paddle.setScale(tiles_size.x)
	right_paddle.setScale(tiles_size.x)
	# Position the right paddle as far from the border as the left one
	left_paddle.position.x = 2 * tiles_size.x
	left_paddle.position.y = viewport_size.y / 2 #- left_paddle.get_rect().size.y / 2
	right_paddle.position.x = viewport_size.x - left_paddle.position.x
	right_paddle.position.y = left_paddle.position.y
	# Set ball at center
	ball.position = viewport_size / 2
	ball.set_random_direction()

	# Initial speed
	ball.speed = 500
	left_paddle.speed = 500
	right_paddle.speed = 500

func reset_ball():
	ball.position = viewport_size / 2
	ball.speed = 500
	ball.set_random_direction()
	ball_color = 1
	ball.sprite.modulate = Color(1, ball_color, ball_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# User control
#	if Input.is_action_pressed("ui_up"):
#		left_paddle.move(Vector2.UP, delta)
#	if Input.is_action_pressed("ui_down"):
#		left_paddle.move(Vector2.DOWN, delta)

	# AI
	var offset = 1 * tiles_size.x
	if ball.get_rect().get_center().y + offset > right_paddle.get_rect().get_center().y:
		right_paddle.move(Vector2.DOWN, delta)
	elif ball.get_rect().get_center().y - offset < right_paddle.get_rect().get_center().y:
		right_paddle.move(Vector2.UP, delta)

	# AI left
	if ball.get_rect().get_center().y + offset > left_paddle.get_rect().get_center().y:
		left_paddle.move(Vector2.DOWN, delta)
	elif ball.get_rect().get_center().y - offset < left_paddle.get_rect().get_center().y:
		left_paddle.move(Vector2.UP, delta)

	# Paddle hit
	if ball.collides(left_paddle.get_rect()) or ball.collides(right_paddle.get_rect()):
		ball.reflectX()
		ball.speed *= 1.05
		ball_color -= .1 * ball_color
		ball.sprite.modulate = Color(1, ball_color, ball_color)
		paddle_sound.play()

	# Wall hit
	if ball.position.y <= 0 or ball.position.y >= viewport_size.y:
		ball.reflectY()
		wall_hit_sound.play()

	# Score
	if ball.position.x < 0 or ball.position.x > viewport_size.x:
		score_sound.play()
		reset_ball()
