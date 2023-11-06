# this script keeps track of daily challenge events during gameplay
# on event, emits signal along with array of descriptions of task completion states
# consumed by the daily challenges screen

# also keeps track of task completion
# on completion, emits signal along with the actual task dictionary object
# consumed by the daily challenges popup manager

# also tracks when the daily challenge is complete
# emits a signal to be consumed by the daily challenge popup manager

extends Node
var curr_coins_collected = 0
var curr_shields_used = 0
var curr_hover_used = 0
var curr_roofs_driven = 0
var goal_coins = 0
var goal_shields_used = 0
var goal_hover_used = 0
var goal_roofs_driven = 0
var task_descriptions = Array()  # descriptions of up-to-date task progress
var daily_challenge: DailyChallenge = null
var completed_tasks: Dictionary = {} # keeps track of completed tasks
var daily_challenge_is_fetched = false # prevents processing unfetched daily challenge
var daily_challenge_not_completed = true # prevents repeated signaling when daily challenge completed
signal task_progressed
signal task_completed
signal daily_challenge_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the daily challenge (from storage or remote)
	$DailyChallenge.get_daily_challenge()

# update the task descriptions list when task progress is made in gameplay
func update_task_descriptions():
	# don't try to use unfetched daily challenge model
	if not daily_challenge_is_fetched:
		return
	
	# clear the previous descriptions
	task_descriptions.clear()
	
	for task in $DailyChallenge.tasks:
		var task_description: String
		var task_id = task.type + "_" + task.object  # constuct id to keep track 
		var curr_value = get_curr_value(task_id) # get current value of task from gameplay
		
		# check if curr value of task has matched the goal
		if curr_value >= task.goal:
			# set the curr_vale to not go past the goal value
			curr_value = task.goal
			# handler to send a signal if task is found to be completed
			signal_if_task_completed(task, task_id)
			# handler to send a signal if daily challenge is completed
			signal_if_daily_challenge_completed()
		
		# now update task_descriptions to reflect task progress in gameplay
		# construct the task details string
		task_description = task.type.capitalize() \
					+ " " + task.object + ": " \
					+ str(curr_value) \
					+ "/" + str(task.goal)
		# add the details to the task_descriptions
		task_descriptions.append(task_description)
	
	# emit signal with the updated descriptions
	task_progressed.emit(task_descriptions)

# checks if a task is completed and emits appropriate signal	
func signal_if_task_completed(task, task_id):
	# if this task hasnt been previously marked complete
	if not completed_tasks.has(task_id):
		# emit signal along with task data if deemed completed
		task_completed.emit(task)
		# register the task in the completed_tasks dict
		completed_tasks[task_id] = true
		
# checks if the daily challenge is completed and emits appropriate signal	
func signal_if_daily_challenge_completed():
	if daily_challenge_not_completed:
		# if the number tasks completed is the same as the number of tasks given
		if completed_tasks.size() == $DailyChallenge.tasks.size(): 
			# flip flag
			daily_challenge_not_completed = false
			# submit current time (score) of daily challenge completion to GPGS
			if Global.GPGS:
				Global.GPGS.submitLeaderBoardScore(
					Global.CHALLENGE_LEADERBOARD,
					Global.score * 1000) #msecs
				print("Score: " + str(Global.score))
			# emit signal
			#await get_tree().create_timer(6).timeout
			daily_challenge_completed.emit()
	
func _on_coin_collected(coin_count):
	curr_coins_collected = coin_count
	# Update task list and emit signal
	update_task_descriptions()
	
func _on_shield_used(_up_time):
	curr_shields_used += 1
	# Update task list and emit signal
	update_task_descriptions()
	
func _on_hover_used(_on_time):
	curr_hover_used += 1
	# Update task list and emit signal
	update_task_descriptions()
	
func _on_roof_driven_on():
	curr_roofs_driven += 1
	# Update task list and emit signal
	update_task_descriptions()
	
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

func _on_daily_challenge_fetched():
	daily_challenge_is_fetched = true
	# for testing purposes overwrite daily_challenge model
	# $DailyChallenge.tasks = [{"description":"Collect 5 coins","goal":5,"object":"coins","type":"collect"},{"description":"Use 2 hover","goal":2,"object":"hover","type":"use"},{"description":"Use 1 shields","goal":1,"object":"shields","type":"use"}]
	# construct/update the list of tasks of the daily challenge
	update_task_descriptions()
