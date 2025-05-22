extends Node3D
var maxLaps = 9

var raceStart = false

var startPositions = [Vector3(-5.692,-4.092,8.257),Vector3(-2.335,-4.092,5.776),Vector3(1.458,-4.092,1.748),Vector3(5.903,-4.092,-2.52)]

func _ready() -> void:
	GlobalVars.currentTrack = self



@rpc("any_peer","call_local","reliable")
func onRaceStart() -> void:
	
	print("i am the one the one the one")
	var multiplayer = get_tree().get_multiplayer()
	var peer_ids = multiplayer.get_peers()
	peer_ids.append(multiplayer.get_unique_id())
	peer_ids.sort()
	#print("Peer IDS: "+str(peer_ids))
	for i in range(len(peer_ids)):
			#print(i)
		for j in get_parent().get_child_count():
			#print(get_parent().get_child(j))
			if get_parent().get_child(j).name == str(peer_ids[i]):
				get_parent().get_child(j).position = startPositions[i]
	
	GlobalVars.hud.raceStartButton.hide()
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
	
	
