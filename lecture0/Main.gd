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
const VIRTUAL_SIZE = Vector2(432,243)
onready var viewport_size: Vector2 = get_viewport_rect().size
onready var tiles_size: Vector2 = viewport_size / VIRTUAL_SIZE
onready var ball: Ball = $Ball
onready var left_paddle: Paddle = $LeftPaddle
onready var right_paddle: Paddle = $RightPaddle

# Called when the node enters the scene tree for the first time.
func _ready():
	print(tiles_size)
	# Set correct sizes based on our virtual size
	ball.setScale(tiles_size.x)
	left_paddle.setScale(tiles_size.x)
	right_paddle.setScale(tiles_size.x)
	# Position the right paddle as far from the border as the left one
	right_paddle.position.x = viewport_size.x - left_paddle.position.x
	# Set ball at center
	ball.position = viewport_size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ball.collides(left_paddle.get_rect())):
		ball.reflectX()
	if (ball.collides(right_paddle.get_rect())):
		ball.reflectX()
