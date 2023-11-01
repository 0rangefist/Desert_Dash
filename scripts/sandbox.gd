extends Node

var endpoint = "https://0rangefist.pythonanywhere.com/api/daily-challenge"
@onready var http = HTTPRequest.new()

func _ready():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	http.request(endpoint)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	print("response code: " + str(response_code))
	print(json)
