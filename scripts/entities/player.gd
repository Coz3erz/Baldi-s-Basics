extends CharacterBody2D
const speed = 6500 #base speed of player
var sprint_mult = 2 #number to multiply speed by while sprinting
var stamina = 100 #stamina for sprint
var stamina_rate = 20 #rate of stamina change
var sprint = false
var player_direction_str = "up" #player direction in string
var player_direction = Vector2(0,-1) #player direction in vector
var zoom = false #if true player enters state of zoom
const friction = 0.8 #friction to ease player movement
const y_directions = ["up","none","down"] #direction to play animation via string combination (y axis)
const x_directions = ["left","none","right"] #direction to play animation via string combination (x axis)
var notebooks = 1 #number of notebooks
var get_out = preload("res://sounds/entities/baldi/baldi-all-7-notebooks.mp3")#sound
var screech = preload("res://sounds/entities/baldi/BAL_Screech.wav")
var finale_sound = preload("res://sounds/map/Loud_noise_.wav")
var finale = false #to see if the game is in final stage aka over seven notebooks
var exits = 0 #number of exits the player has
var caught = false
@onready var sprite = $player_sprite #player sprite
@onready var animation = $player_sprite/AnimationPlayer #animaton player for reference
@onready var audio = $audio_player #audio node
@onready var camera_target = $"."
var lock = false
#everythings documented , don't worry
func _ready():
	velocity = Vector2.ZERO
func _physics_process(delta):
	stamina = 100
	if Input.is_action_pressed("q") and stamina > 0 and !caught:
		camera_target = $"../Baldi"
		stamina -= stamina_rate*3 * delta
	else:
		camera_target = $"."
	$Camera2D.global_position = camera_target.global_position
	$"../CanvasLayer/Label".text = "notebooks "+str(clamp(notebooks-1,0,7))+"/7"
	zoom = Input.is_action_pressed("e")
	if zoom and stamina > 0 and !caught:
		stamina -= stamina_rate*1.2 * delta
		$Camera2D.zoom -= Vector2(0.1,0.1)
	else:
		$Camera2D.zoom += Vector2(0.1,0.1)
	$Camera2D.zoom = clamp($Camera2D.zoom,Vector2(0.6,0.6),Vector2(1,1))
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if dir and !lock and !Input.is_action_pressed("q"):
		#set player direction
		player_direction = dir
		#getting variable ready for animation
		if Input.is_action_pressed("ui_left"):
			player_direction_str = "left"
		if Input.is_action_pressed("ui_right"):
			player_direction_str = "right"
		if Input.is_action_pressed("ui_up"):
			player_direction_str = "up"
		if Input.is_action_pressed("ui_down"):
			player_direction_str = "down"
		animation.play("run_"+player_direction_str)
		if dir.x == -1: #set direction of animations based on x axis
			sprite.flip_h = true
		if dir.x == 1:
			sprite.flip_h = false
		animation.speed_scale = 2 # setting speed for animation in walk
		if Input.is_action_pressed("shift") and stamina > 1:
			sprint = true
			dir.x *= sprint_mult
			dir.y *= sprint_mult
			stamina -= stamina_rate * delta
			stamina = clamp(stamina,0,100)
			animation.speed_scale = 4 #setting speed for animation since its sprinting
		velocity += dir * speed * delta # run function
	else:
		animation.speed_scale = 2 # setting speed for idle
		if !zoom and !Input.is_action_pressed("q"):
			stamina += stamina_rate*2 * delta #stamina passive
		stamina = clamp(stamina,0,100) #set stamina
		animation.play("idle_"+player_direction_str)
		if dir.x == -1: #set direction of animations based on x axis
			sprite.flip_h = true
		if dir.x == 1:
			sprite.flip_h = false
	$"../CanvasLayer/ProgressBar".value = stamina
	velocity *= friction
	move_and_slide()
func seven_notebooks():
	if notebooks > 7:
		audio.stream = get_out
		audio.play()
		finale = true
func _on_player_hitbox_area_entered(area):
	if area.get_parent().name == "Baldi" and caught == false:
		audio.stream = screech
		audio.play()
		$Node2D.visible = true
		$ColorRect.visible = true
		$"../CanvasLayer".visible = false
		$Camera2D.position_smoothing_speed = 50
		zoom = false
		lock = true
		velocity = Vector2.ZERO
		caught = true
		$"../Baldi".audiostream.set_stream_paused(true)
		$"../Baldi/screech".set_stream_paused(true)
func exit():
	if exits == 2:
		$audio_player.stream = finale_sound
		$"../red_modulate".visible = true
		$audio_player.play()
	if exits == 4:
		get_tree().change_scene_to_file("res://win.tscn")
func _on_audio_player_finished():
	if audio.stream == preload("res://sounds/entities/baldi/BAL_Screech.wav"):
		get_tree().reload_current_scene()
	if audio.stream == preload("res://sounds/map/loud_noise_.wav"):
		audio.stream = finale_sound
		audio.play()
