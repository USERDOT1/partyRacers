extends Node3D
@onready var kart = $Kart
var maxLaps = 5

var raceStart = false


func _ready() -> void:
		$Hud/StartCountdown.text = "3"
		await get_tree().create_timer(2).timeout
		$Hud/StartCountdown.text = "2"
		await get_tree().create_timer(2).timeout
		$Hud/StartCountdown.text = "1"
		await get_tree().create_timer(2.5).timeout
		$Hud/StartCountdown.text = "GO!"
		raceStart = true
		await get_tree().create_timer(1.5).timeout
		$Hud/StartCountdown.text = ""
