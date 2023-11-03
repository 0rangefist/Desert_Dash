extends CanvasLayer

@export_group("Scene to Load Next")
@export_file("*.tscn") var scene_path: String

var progress: Array[float] = []
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	# Load the scene in the background
	ResourceLoader.load_threaded_request(scene_path)

func _process(_delta):
	# get the current load status
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	# keep displaying loading screen if scene not ready (still in progress)
	if load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		# update progress bar UI based on loading progress
		print("PROGRESS: ")
	# else switch to the new scene if it is ready
	elif load_status == ResourceLoader.THREAD_LOAD_LOADED:
		# don't call process again if switching scenes
		#set_process(false)
		# obtain the fully loaded scene
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(scene_path)
		# switch to the new fully loaded scene
		get_tree().change_scene_to_packed(new_scene)
	else:
		# if there is some kind of error
		print("Error. Could not transition from loading screen to scene: " + scene_path)
