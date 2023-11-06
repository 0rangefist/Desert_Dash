extends Node

var score = 0 # score in seconds
var coin_count = 0
var GPGS
const CHALLENGE_LEADERBOARD = "CgkIyv2UyaEfEAIQAg"
const SURVIVAL_LEADERBOARD = "CgkIyv2UyaEfEAIQAQ"

func _ready():
	if Engine.has_singleton("GodotPlayGamesServices"):
		GPGS = Engine.get_singleton("GodotPlayGamesServices")
		GPGS.connect("_on_leaderboard_score_submitted", _on_leaderboard_score_submitted)
		GPGS.connect("_on_leaderboard_score_submitting_failed", _on_leaderboard_score_submitting_failed)
		
func _on_leaderboard_score_submitted(leaderboard_id: String):
	print("Leaderboard submission success: " + leaderboard_id + " " + str(Global.score * 1000))

func _on_leaderboard_score_submitting_failed(leaderboard_id: String):
	print("Leaderboard submission fail: " + leaderboard_id)

# format time from secs to 00m:00s
func format_time(total_time):
	var minutes = int(total_time / 60)
	var seconds = total_time % 60
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
