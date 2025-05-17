extends Node

var peer = ENetMultiplayerPeer.new()
const playerKart = preload("res://kart/kart.tscn")

func hostGame():
	peer.create_server(8910,2)
	
	multiplayer.multiplayer_peer = peer
	 
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game")
			add_player(pid)
	)
	
	add_player(1)#Host so 1 (pretty cool huh)
	await await get_tree().create_timer(1).timeout
	GlobalVars.gameHosted = true
	
func joinGame():
	peer.create_client("172.88.97.9",8910,2)
	multiplayer.multiplayer_peer = peer

func add_player(playerName):
	var player = playerKart.instantiate()
	player.name = str(int(playerName))
	add_child(player)
	print(playerName)
