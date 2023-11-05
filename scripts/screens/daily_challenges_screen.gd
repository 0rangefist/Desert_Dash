extends Control

@onready var daily_challenge = $DailyChallenge

func _ready():
	# get the the latest daily challenge
	daily_challenge.get_daily_challenge()
	#daily_challenge.daily_challenge_fetched.connect(_on_daily_challenge_fetched)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_daily_challenge_to_ui():
	var rich_text = $RichTextLabel
	# add the daily challenge task descriptions to the rich text label
	for task in daily_challenge.tasks:
		rich_text.append_text("[center]\u2022 " + task.description + "[/center]\n")

func _on_daily_challenge_fetched():
	add_daily_challenge_to_ui()

func _on_close_button_pressed():
	hide()
