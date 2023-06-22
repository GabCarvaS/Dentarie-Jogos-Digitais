extends Node2D

@onready var player_spawn_pos = $PlayerSpawnPosition
@onready var laser_container  =$LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var game_over_scrn = $UILayer/GameOverScreen


@export var enemy_scenes: Array[PackedScene] = []

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score

var high_score = 0


func  _ready():
	score = 0
	player = get_tree().get_first_node_in_group("player")
	assert(player!=null)
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(on_player_killed)

func  _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location 
	laser_container.add_child(laser)


func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50,500),-50)
	e.killed.connect(_on_enemy_killed)
	enemy_container.add_child(e)

func _on_enemy_killed(points):
	score += points
	if score > high_score:
		high_score = score
	print(score)

func on_player_killed():
	game_over_scrn.set_score(score)
	game_over_scrn.set_high_score(high_score)
	await get_tree().create_timer(1).timeout
	game_over_scrn.visible = true
