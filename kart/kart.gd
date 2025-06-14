extends VehicleBody3D

@export var baseEnginePower = 300
@export var turnSpeed = 6
@export var tireCondition = 1.2
var maxBattery = 60

var cold_mod = 1
var cold_recovery = 0.2

var inPit = false
var tireType = "Medium"
var tireList = ["Soft", "Medium", "Hard"]
var tireIndex = 1

@export var itemList = ["Boost","Phase", "Freeze"]

var softDegDiv = 10
var mediumDegDiv = 30 #Medium Tire Degs 3x Slower than soft
var hardDegDiv = 90 #Hard Tire Degs 

var battery = 30
var spendingList = ["Ultra Recharge", "Big Recharge", "Recharge", "Balanced", "Spend", "Big Spend", "Ultra Spend"]
var spendingIndex = 3
var spendingType = spendingList[spendingIndex]

var phazed = false

var freezeInstance #for freeze
var bulletInstance

var bonus = 1

var timer = 0
var bestTime = 1000
var inTrack = true
var identification = "kart"

var playerDirectionF 




var kartBaseFriction = 10.5
var kartBaseFlipResistence = 0.1
var maxSteering = 0.5

var ourItems = []

var laps = 0

var checkpointPassed = true


var flipped = false

var boostFalloff = 150

var boostPower = 570
var phaseDistance = 18

var fastestLapTime = 1000
var fastestLapPlayer = "none"

var laptime = 1000
func _ready() -> void:
	
	tireType = tireList[tireIndex]
	GlobalVars.hud.spending = spendingType
	#Setting wheel friction to a variable
	$FrontLeft.wheel_friction_slip = kartBaseFriction
	$FrontRight.wheel_friction_slip = kartBaseFriction
	$BackRight.wheel_friction_slip = kartBaseFriction
	$BackLeft.wheel_friction_slip = kartBaseFriction
	
	#Setting the kart roll influence to a variable
	$FrontLeft.wheel_roll_influence = kartBaseFlipResistence
	$FrontRight.wheel_roll_influence = kartBaseFlipResistence
	$BackRight.wheel_roll_influence = kartBaseFlipResistence
	$BackLeft.wheel_roll_influence = kartBaseFlipResistence
	
func _enter_tree() -> void:
	set_multiplayer_authority(int(name))
	if is_multiplayer_authority():
		
		GlobalVars.kart = self



func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		$CarBody.material_override = load("res://materials/blueKart.tres")
		return
	else:
		$Playercam.make_current()
		$Name.text = GlobalVars.myName
		$Name.modulate = GlobalVars.myNameColor
		GlobalVars.kart = self
	
	if (cold_mod + delta * cold_recovery) < 1:
		cold_mod += delta * cold_recovery 
	else:
		cold_mod = 1
	
	GlobalVars.hud.coldTexture.modulate.a = 1-cold_mod
	
	playerDirectionF = global_transform.basis.z.normalized()
	if Input.is_action_just_pressed("usePowerup"):
		usePowerup()
	if Input.is_action_just_pressed("usePowerup"):
		pass
	spendingType = spendingList[spendingIndex]#Updates spendingtype every frame
	GlobalVars.hud.spending = spendingType
	# If we are in the track, increase the timer
	if inTrack and GlobalVars.currentTrack.raceStart:
		timer += delta
		laptime += delta
	
	#Hotkeys for Changing Battery
	if Input.is_action_just_pressed("ChangeBatteryUp"):
		if spendingIndex == 6:
			print("MAX SPEND") #ADD SOMETHING VISUAL
		else:
			spendingIndex = (spendingIndex + 1) 
			spendingType = spendingList[spendingIndex]
			GlobalVars.hud.spending = spendingType
			#print(spendingType)
	if Input.is_action_just_pressed("ChangeBatteryDown"):
		if spendingIndex == 0:
			print("MAX RECHARGE") #ADD SOMETHING VISUAL (FR)
		else:
			spendingIndex = (spendingIndex - 1) 
			spendingType = spendingList[spendingIndex]
			GlobalVars.hud.spending = spendingType
			#print(spendingType)
	
	# Subject to change in the future from a multiplyer to an addative
	if spendingType == "Ultra Recharge" && GlobalVars.currentTrack.raceStart:
		bonus = 0.5
		battery += 1.8*delta
		
	elif spendingType == "Big Recharge" && GlobalVars.currentTrack.raceStart:
		bonus = 0.65
		battery += 1.3*delta
	elif spendingType == "Recharge" && GlobalVars.currentTrack.raceStart:
		bonus = 0.8
		battery += delta
	elif spendingType == "Balanced" && GlobalVars.currentTrack.raceStart:
		bonus = 1
	elif spendingType == "Spend" && GlobalVars.currentTrack.raceStart:
		bonus = 1.2
		if battery - (delta) > 0:
			battery -= delta
		else: #adjusts battery back to balance
			spendingIndex = 3
			
	elif spendingType == "Big Spend" && GlobalVars.currentTrack.raceStart:
		bonus = 1.35
		if battery - (1.3*delta) > 0:
			battery -= 1.3*delta
		else: 
			spendingIndex = 3
			
	elif spendingType == "Ultra Spend" && GlobalVars.currentTrack.raceStart:
		bonus = 1.5
		if battery - (1.8*delta) > 0:
			battery -= 1.8*delta
		else:
			print('ELSE')
			spendingIndex = 3
			
	
	#Clamp battery
	battery = clamp(battery,0,maxBattery)
	
	if GlobalVars.currentTrack.raceStart:
		#print("racestart")
		#Steering based on the tireCondition, maxing out at maxSteering
		steering = move_toward(steering,Input.get_axis("turnRight","turnLeft") * maxSteering, delta * turnSpeed * tireCondition * cold_mod)
		engine_force = Input.get_axis("break","throttle") * (baseEnginePower)* bonus
	
	
	
	# Degrading tire condition based on above variables
	if GlobalVars.tiresDegradeForMe:
		if tireType == "Soft":
			tireCondition -= (abs($FrontLeft.get_rpm()) + abs($FrontRight.get_rpm()) + abs($BackRight.get_rpm()) + abs($BackLeft.get_rpm()))/(softDegDiv*1000000)
		elif tireType == "Medium":
			tireCondition -= (abs($FrontLeft.get_rpm()) + abs($FrontRight.get_rpm()) + abs($BackRight.get_rpm()) + abs($BackLeft.get_rpm()))/(mediumDegDiv*1000000)
		elif tireType == "Hard":
			tireCondition -= (abs($FrontLeft.get_rpm()) + abs($FrontRight.get_rpm()) + abs($BackRight.get_rpm()) + abs($BackLeft.get_rpm()))/(hardDegDiv*1000000)
	
	#clamps tire condition (never going to hit the top, just the bottom)
	tireCondition = clamp(tireCondition, 0.2, 100)
	if (rotation_degrees.x > 30 || rotation_degrees.x < -30) || (rotation_degrees.z > 30 || rotation_degrees.z < -30):
		flipped = true
		if Input.is_action_just_pressed("Flip"):
			rotation_degrees.x = 0
			rotation_degrees.z = 0
			position.y += 5
			angular_velocity = Vector3(0,0,0)
			linear_velocity = Vector3(0,0,0)
	else:
		flipped = false
		
	if inPit:
		if Input.is_action_just_pressed("ChangeWheelsUp"):
			if tireIndex == 2:
				print('Maxed out (cant make tires harder)')#add visual
				tireCondition = 0.85
			else:
				tireIndex = (tireIndex + 1)
				tireType = tireList[tireIndex]
				if tireList[tireIndex] == "Hard":
					tireCondition = 0.85
				if tireList[tireIndex] == "Medium":
					tireCondition = 1.2
		if Input.is_action_just_pressed("ChangeWheelsDown"):
			if tireIndex == 0:
				print('Maxed out (cant make tires softer)')#add visual
				tireCondition = 2
			else:
				tireIndex = (tireIndex - 1)
				tireType = tireList[tireIndex]
				if tireList[tireIndex] == "Medium":
					tireCondition = 1.2
				if tireList[tireIndex] == "Soft":
					tireCondition = 2


func powerup():
	if len(ourItems) < 3:
		#if we have less than 3 items add another
		ourItems.append(itemList.pick_random())
		print(ourItems)
		
func usePowerup():
	if len(ourItems) > 0:
		if ourItems[0] == "Boost":
			apply_central_impulse(playerDirectionF * boostPower)
		
		elif ourItems[0] == "Phase":
			# wait 2 seconds
			$PhaseSound.play()
			global_position += playerDirectionF * phaseDistance
		elif ourItems[0] == "Freeze":
			freezeInstance = load("res://freeze_beam.tscn").instantiate()
			add_child(freezeInstance)
			$IceBeam.play()
			#bulletInstance = load("res://kart/bullet/bullet.tscn").instantiate()
			#bulletInstance.startPosition = global_position
			#bulletInstance.startRotation = global_rotation
			#bulletInstance.playerDirection = playerDirectionF
			#bulletInstance.playerForce = linear_velocity
			#get_parent().add_child(bulletInstance)
	 #
		
		
		
		
		
		#PUT ALL ITEM CODE ABOVE HERE
		
		ourItems.remove_at(0)
		
		 
			


func areaEntered(area: Area3D) -> void:
	#Checking if we entered pit, or started or finished a race
	#if area.name == "Start":
	#	inTrack = true
	if area.name == "Finish":
		if checkpointPassed:
			checkpointPassed = false
			if laps != (GlobalVars.currentTrack.maxLaps):
				laps += 1
				laptime = 0
			else:
				if bestTime > timer:
					bestTime = timer
				timer = 0
				laps = 1
				laptime = 0
	if area.name == "PitstopArea":
		inPit = true
		print("entered Pit")
	elif area.name == "Checkpoint":
		checkpointPassed = true
	
	
	elif area.name == "freezeArea":
		print('HIT')
		cold_mod = 0.1
		$Frozen.play()
	
func _on_area_3d_area_exited(area: Area3D) -> void:
	#If exiting pit, setting it to false
	if area.name == "PitstopArea":
		inPit = false
		print("exited Pit")
		
