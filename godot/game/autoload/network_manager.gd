extends Node

var http_request: HTTPRequest

func _ready() -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	get_leaderboard()


func _on_request_completed(result, response_code, headers, body):
	var res = body.get_string_from_utf8()
	print(res)


# add a guard for no internet, same with get_leaderboard()
func post_player_result(player_name: String, score: int):
	var url = "http://localhost:3000/submit" # change to custom url
	var body = JSON.stringify({
		"player_name": player_name,
		"score": score
		})
	
	var headers = ["Content-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)


func get_leaderboard():
	var url = "https://gamified-cybersecurity-awareness-training.onrender.com/leaderboard"
	http_request.request(url)
