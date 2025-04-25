extends VehicleBody3D


@export var baseEnginePower = 300
@export var turnSpeed = 6
@export var tireCondition = 1.2
@export var maxBattery = 100

var pitstopStatus = false
var tireType = "Medium"
var tireList = ["Soft", "Medium", "Hard"]
var tireIndex = 1


var softDegDiv = 10
var mediumDegDiv = 30 #Medium Tire Degs 3x Slower than soft
var hardDegDiv = 60 #Hard Tire Degs 

var battery = 50
var spendingList = ["Ultra Recharge", "Big Recharge", "Recharge", "Balanced", "Spend", "Big Spend", "Ultra Spend"]
var spendingIndex = 3
var spendingType = spendingList[spendingIndex]


var bonus = 1

var timer = 0
var bestTime = 100
var inTrack = false
var identification = "kart"


var oogaBonus = 0

var kartBaseFriction = 10.5
var kartBaseFlipResistence = 0.2
var maxSteering = 0.5

var ourItems = []
func _ready() -> void:
	tireType = tireList[tireIndex]
	$"../CanvasLayer/Hud/SpendingType".text = spendingType
func _physics_process(delta: float) -> void:
	$FrontLeft.wheel_friction_slip = kartBaseFriction
	$FrontRight.wheel_friction_slip = kartBaseFriction
	$BackRight.wheel_friction_slip = kartBaseFriction
	$BackLeft.wheel_friction_slip = kartBaseFriction
	$FrontLeft.wheel_roll_influence = kartBaseFlipResistence
	$FrontRight.wheel_roll_influence = kartBaseFlipResistence
	$BackRight.wheel_roll_influence = kartBaseFlipResistence
	$BackLeft.wheel_roll_influence = kartBaseFlipResistence
	if inTrack:
		timer += delta
	if spendingType == "Ultra Recharge":
		bonus = 0.5
		battery += 1.8*delta
		
	elif spendingType == "Big Recharge":
		bonus = 0.65
		battery += 1.3*delta
	elif spendingType == "Recharge":
		bonus = 0.8
		battery += delta
	elif spendingType == "Balanced":
		bonus = 1
	elif spendingType == "Spend":
		bonus = 1.2
		if battery - (delta) > 0:
			battery -= delta
		else:
			$"../CanvasLayer/Hud/BatterySpending".selected = 3
	elif spendingType == "Big Spend":
		bonus = 1.35
		if battery - (1.3*delta) > 0:
			battery -= 1.3*delta
		else:
			$"../CanvasLayer/Hud/BatterySpending".selected = 3
	elif spendingType == "Ultra Spend":
		bonus = 1.5
		if battery - (1.8*delta) > 0:
			battery -= 1.8*delta
		else:
			$"../CanvasLayer/Hud/BatterySpending".selected = 3
	
	battery = clamp(battery,0,maxBattery)
	#print(bonus)
	steering = move_toward(steering,Input.get_axis("turnRight","turnLeft") * maxSteering, delta * turnSpeed * tireCondition)
	engine_force = Input.get_axis("break","throttle") * baseEnginePower * bonus
	if tireType == "Soft":
		tireCondition -= (abs($FrontLeft.get_rpm()) + abs($FrontRight.get_rpm()) + abs($BackRight.get_rpm()) + abs($BackLeft.get_rpm()))/(softDegDiv*1000000)
	elif tireType == "Medium":
		tireCondition -= (abs($FrontLeft.get_rpm()) + abs($FrontRight.get_rpm()) + abs($BackRight.get_rpm()) + abs($BackLeft.get_rpm()))/(mediumDegDiv*1000000)
	elif tireType == "Hard":
		tireCondition -= (abs($FrontLeft.get_rpm()) + abs($FrontRight.get_rpm()) + abs($BackRight.get_rpm()) + abs($BackLeft.get_rpm()))/(hardDegDiv*1000000)
	
	tireCondition = clamp(tireCondition, 0.2, 100)
	#print(tireCondition)
	
	#Hotkeys for Changing Battery
	if Input.is_action_just_pressed("ChangeBatteryUp"):
		if spendingIndex == 6:
			print("MAX SPEND") #ADD SOMETHING VISUAL
		else:
			spendingIndex = (spendingIndex + 1) 
			spendingType = spendingList[spendingIndex]
			$"../CanvasLayer/Hud/SpendingType".text = spendingType
			#print(spendingType)
	if Input.is_action_just_pressed("ChangeBatteryDown"):
		if spendingIndex == 0:
			print("MAX RECHARGE") #ADD SOMETHING VISUAL
		else:
			spendingIndex = (spendingIndex - 1) 
			spendingType = spendingList[spendingIndex]
			$"../CanvasLayer/Hud/SpendingType".text = spendingType
			#print(spendingType)
	if pitstopStatus == true:
		if Input.is_action_just_pressed("ChangeWheelsUp"):
			if tireIndex == 2:
				print('MAX HARD TIRES')#add visual
			else:
				tireIndex = (tireIndex + 1)
				tireType = tireList[tireIndex]
		if Input.is_action_just_pressed("ChangeWheelsDown"):
			if tireIndex == 0:
				print('MAX SOFT TIRES')#add visual
			else:
				tireIndex = (tireIndex - 1)
				tireType = tireList[tireIndex]
	else:
		print("NOT IN PITSTOP") #ADD VISUAL
			


func powerup():
	if len(ourItems) < 3:
		ourItems.append(get_parent().itemList.pick_random())
		print(ourItems)
		


func areaEntered(area: Area3D) -> void:
	if area.name == "Start":
		inTrack = true
	elif area.name == "Finish":
		if inTrack:
			inTrack = false
			if bestTime > timer:
				bestTime = timer
			timer = 0
	if area.name == "PitstopArea":
		pitstopStatus = true

	
func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.name == "PitstopArea":
		pitstopStatus = false
