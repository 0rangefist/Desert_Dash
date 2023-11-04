extends CheckButton

@export var bus_name: String
@onready var bus_index = AudioServer.get_bus_index(bus_name)

func _ready():
	# get current state of the bus
	if AudioServer.is_bus_mute(bus_index):
		button_pressed = false
	else:
		button_pressed = true


func _on_toggled(enable):
	AudioServer.set_bus_mute(bus_index, !enable)
