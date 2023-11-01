extends Node
var curr_coins_collected = 0
var curr_shields_used = 0
var curr_hover_used = 0
var curr_roofs_driven = 0
var goal_coins = 0
var goal_shields_used = 0
var goal_hover_used = 0
var goal_roofs_driven = 0
var task_list = Array()
var daily_challenge: DailyChallenge = null
var task_completions: Dictionary = {}
signal challenge_task_updated
signal task_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the daily challenge (from storage or remote)
	daily_challenge = await DailyChallenge.new()
	task_list =  Array()
	# construct/update the list of tasks of the daily challenge
	update_tasks()
	# emit signal along with the updated task list
	challenge_task_updated.emit(task_list)

func update_tasks():
	for task in daily_challenge.tasks:
		var task_details: String
		var task_id = task.type + "_" + task.object
		var curr_value = get_curr_value(task_id)
		
		# check if curr value of task is has matched the goal
		if curr_value >= task.goal:
			# Peg the curr value at the goal value
			curr_value = task.goal
			# if this task hasnt been previously marked complete
			if not task_completions.has(task_id):
				# emit signal that task has been completed
				task_completed.emit(task_id)
				# register the task in the task_completions dict
				task_completions[task_id] = true
		
		# Construct the task details string
		task_details = task.type.capitalize() \
					+ " " + task.object + ": " \
					+ str(curr_value) \
					+ "/" + str(task.goal)
		# Add the details to the task_list
		task_list.append(task_details)

func _on_coin_collected(coin_count):
	curr_coins_collected = coin_count
	# Update task list and emit signal
	update_tasks()
	challenge_task_updated.emit(task_list)
	
func _on_shield_used(_up_time):
	curr_shields_used += 1
	# Update task list and emit signal
	update_tasks()
	challenge_task_updated.emit(task_list)
	
func _on_hover_used(_on_time):
	curr_hover_used += 1
	# Update task list and emit signal
	update_tasks()
	challenge_task_updated.emit(task_list)
	
func _on_roof_driven_on():
	curr_roofs_driven += 1
	# Update task list and emit signal
	update_tasks()
	challenge_task_updated.emit(task_list)
	
func get_curr_value(object_type: String) -> int:
	match object_type:
		"collect_coins":
			return curr_coins_collected
		"use_shields":
			return curr_shields_used
		"use_hover":
			return curr_hover_used
		"drive-on_roofs":
			return curr_roofs_driven
	return 0  # Default value for an unknown object type
