extends Node3D
var maxLaps = 5

var raceStart = false


func _ready() -> void:
	GlobalVars.currentTrack = self
	GlobalVars.startCountdown.text = "3"
	await get_tree().create_timer(2).timeout
	GlobalVars.startCountdown.text = "2"
	await get_tree().create_timer(2).timeout
	GlobalVars.startCountdown.text = "1"
	await get_tree().create_timer(2.5).timeout
	GlobalVars.startCountdown.text = "GO!"
	raceStart = true
	await get_tree().create_timer(1.5).timeout
	GlobalVars.startCountdown.text = ""
