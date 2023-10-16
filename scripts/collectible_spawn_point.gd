extends Node3D

@export_range(0.0, 1.0, 0.1) var coin_probability: float  = 0.6
@export_range(0.0, 1.0, 0.1) var magnet_probability: float  = 0.2
@export_range(0.0, 1.0, 0.1) var shield_probability: float  = 0.1
# 0.1 for no_spawn probability

# we could spawn 3, 4 ... or 10 coins
@export var min_coin_num: int = 3
@export var max_coin_num: int = 10

var coin: PackedScene
var magnet: PackedScene
var shield: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	# preload all the collectibles for spawning
	coin = preload("res://scenes/objects/coin.tscn")
	magnet = preload("res://scenes/objects/magnet.tscn")
	shield = preload("res://scenes/objects/shield.tscn")
	
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
		
func spawn_collectible(collectible: PackedScene):
	# coins are special and are spawned in multiples
	if collectible == coin:
		var coin_array = []
		var coin_num = randi_range(min_coin_num, max_coin_num)
		# spawn coin_num of coins 
		var pos = 0
		for i in range(0, coin_num):
			var coin_instance = collectible.instantiate()
			add_child(coin_instance)
			coin_instance.position.z = pos
			# offset coin by -2 from the last on the Z-axis
			pos -= 2
	else: # shields and magnets are spawned in singles
		var instance = collectible.instantiate()
		add_child(instance)
	
