extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	test_level_loader()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func test_level_loader():
	var level_loader = LevelLoader.new()
	level_loader.load_level("desert")  # Replace "Level1" with the desired level name

	# Log the loaded unit scenes
	for unit_scene in level_loader.level_units:
		# create an instance
		var unit = unit_scene.instantiate()
		print("Loaded unit instance:", unit.visible)
		add_child(unit)
