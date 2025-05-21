extends Node3D
var maxLaps = 9

var raceStart = false


func _ready() -> void:
	GlobalVars.currentTrack = self



@rpc("any_peer","call_local","reliable")
func onRaceStart() -> void:
	GlobalVars.startCountdown.text = "3"
	await get_tree().create_timer(1).timeout
	GlobalVars.startCountdown.text = "2"
	await get_tree().create_timer(1).timeout
	GlobalVars.startCountdown.text = "1"
	await get_tree().create_timer(1).timeout
	GlobalVars.startCountdown.text = "GO!"
	raceStart = true
	await get_tree().create_timer(1.6).timeout
	GlobalVars.startCountdown.text = ""
	
	GlobalVars.hud.raceStartButton.hide()
