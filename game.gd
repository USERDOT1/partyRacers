extends Node

const playerKart = preload("res://kart/kart.tscn")
var peer := WebSocketMultiplayerPeer.new()

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		var err = peer.create_server(8910, "*")
		if err != OK:
			print("Failed to start WebSocket server:", err)
			return

		print("Running dedicated WebSocket server")
		multiplayer.multiplayer_peer = peer
		
		multiplayer.peer_connected.connect(
			func(pid):
				print("Peer " + str(pid) + " has joined the game")
				add_player(pid)
		)

		await get_tree().create_timer(1).timeout
		GlobalVars.gameHosted = true

	print("Ready")
	Console.add_command("turnOnTireDegSelf", console_turnOnTireDegSelf)
	Console.add_command("turnOffTireDegSelf", console_turnOffTireDegSelf)
	Console.add_command("turnOnTireDegAll", console_turnOnTireDegAll.rpc)
	Console.add_command("turnOffTireDegAll", console_turnOffTireDegAll.rpc)

func console_turnOnTireDegSelf():
	Console.print_line("Tires will degrade!")
	GlobalVars.tiresDegradeForMe = true

func console_turnOffTireDegSelf():
	Console.print_line("Tires will not degrade!")
	GlobalVars.tiresDegradeForMe = false

@rpc("any_peer", "call_local", "reliable")
func console_turnOnTireDegAll():
	Console.print_line("Tires will degrade for everyone!")
	GlobalVars.tiresDegradeForMe = true

@rpc("any_peer", "call_local", "reliable")
func console_turnOffTireDegAll():
	Console.print_line("Tires will not degrade for everyone!")
	GlobalVars.tiresDegradeForMe = false

func hostGame():
	if not OS.has_feature("web"):
		var err = peer.create_server(8910, "*")
		if err != OK:
			print("Failed to host WebSocket server:", err)
			return

		multiplayer.multiplayer_peer = peer

		multiplayer.peer_connected.connect(
			func(pid):
				print("Peer " + str(pid) + " has joined the game")
				add_player(pid)
		)
		add_player(1) # Host
		await get_tree().create_timer(1).timeout
		GlobalVars.gameHosted = true

func joinGame():
	var err = peer.create_client("3.82.241.6")
	if err != OK:
		print("Failed to connect to server:", err)
		return
	multiplayer.multiplayer_peer = peer

func add_player(playerName):
	var player = playerKart.instantiate()
	player.name = str(int(playerName))
	add_child(player)
