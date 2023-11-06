extends Control

@onready var daily_challenge = $DailyChallenge
# Store the previous task descriptions
var previous_task_descriptions = []

func _ready():
	# get the the latest daily challenge
	daily_challenge.get_daily_challenge()

# initialise ui with task descriptions from the daily challenge model
func initialise_ui():
	# Clear any previous text in the label
	$RichTextLabel.text = ""
	# add the daily challenge task descriptions to the rich text label
	for task in daily_challenge.tasks:
		$RichTextLabel.append_text("[center]\u2022 " + task.description + "[/center]\n")

# initialise the ui when the daily challenge is succefully fetched
func _on_daily_challenge_fetched():
	initialise_ui()

# updates ui with descriptions detailing latest task progress in the game
func update_ui(task_descriptions):
	# construct a rich text string from the task descriptions array
	var formatted_descriptions = ""
	for task_description in task_descriptions:
		formatted_descriptions += "[center]\u2022 " + task_description + "[/center]\n"
	# update the rich text label with the formatted_description string
	$RichTextLabel.text = formatted_descriptions

# update the ui, when a daily challenge task progresses
func _on_daily_challenge_task_progressed(task_descriptions):
	update_ui(task_descriptions)


# hide the screen when appropriate button pressed
func _on_close_button_pressed():
	hide()
