extends Node3D

@export_range(0.0, 1.0, 0.1) var coin_probability: float  = 0.2
@export_range(0.0, 1.0, 0.1) var magnet_probability: float  = 0.1
@export_range(0.0, 1.0, 0.1) var shield_probability: float  = 0.1
@export_range(0.0, 1.0, 0.1) var hover_probability: float  = 0.1

#@export_range(0.0, 1.0, 0.1) var coin_probability: float  = 0.6
#@export_range(0.0, 1.0, 0.1) var magnet_probability: float  = 0.2
#@export_range(0.0, 1.0, 0.1) var shield_probability: float  = 0.1
#@export_range(0.0, 1.0, 0.1) var hover_probability: float  = 0.1

#@export_range(0.0, 1.0, 0.1) var coin_probability: float  = 0
#@export_range(0.0, 1.0, 0.1) var magnet_probability: float  = 0
#@export_range(0.0, 1.0, 0.1) var shield_probability: float  = 0.5
#@export_range(0.0, 1.0, 0.1) var hover_probability: float  = 0.5
# 0.1 for no_spawn probability

# we could spawn 3, 4 ... or 10 coins
@export var min_coin_num: int = 3
@export var max_coin_num: int = 10
@export_range(0.0, 3.0, 0.5) var coin_spacing: float = 1.5

var coin: PackedScene
var magnet: PackedScene
var shield: PackedScene
var hover: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# preload all the collectibles for spawning
	coin = preload("res://scenes/objects/coin.tscn")
	magnet = preload("res://scenes/objects/magnet.tscn")
	shield = preload("res://scenes/objects/shield.tscn")
	hover = preload("res://scenes/objects/hover.tscn")
	
	# randomly spawn a collectible (solo or group)
	spawn_collectibles()

func spawn_collectibles():
	# get random float between 0.0 and 1.0
	var rand_num = randf()
	
	if rand_num < coin_probability:
		spawn_collectible(coin)
	elif rand_num < coin_probability + magnet_probability:
		spawn_collectible(magnet)
	elif rand_num < coin_probability + magnet_probability + shield_probability:
		spawn_collectible(shield)
	elif rand_num < coin_probability + magnet_probability + shield_probability + hover_probability:
		spawn_collectible(hover)
		
func spawn_collectible(collectible: PackedScene):
	# coins are special and are spawned in multiples
	if collectible == coin:
		var coin_num = randi_range(min_coin_num, max_coin_num)
		# spawn coin_num of coins 
		var pos_left = 0
		var pos_right = -1 * coin_spacing
		var pos_is_left = true
		for i in range(0, coin_num):
			var coin_instance = collectible.instantiate()
			add_child(coin_instance)
			if pos_is_left:
				coin_instance.position.z = pos_left
				# setup position for next coin to the left
				pos_left += coin_spacing
				pos_is_left = false
			else:
				coin_instance.position.z = pos_right
				# setup position for next coin to the right
				pos_right -= coin_spacing
				pos_is_left = true
	else: # shields, magnets & hover packs are spawned in singles
		var instance = collectible.instantiate()
		add_child(instance)
	
