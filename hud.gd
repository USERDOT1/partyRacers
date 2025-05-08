extends Control
var spending = "balanced"

@onready var kart = get_parent().get_parent()
func _init() -> void:
	GlobalVars.hud = self
	
func _process(delta: float) -> void:
	if len(GlobalVars.kart.ourItems) > 0:
		$Item1.animation = GlobalVars.kart.ourItems[0]
	else:
		$Item1.animation = "Empty"
		$Item2.animation = "Empty"
		$Item3.animation = "Empty"
	if len(GlobalVars.kart.ourItems) > 1:
		$Item2.animation = GlobalVars.kart.ourItems[1]
		print("gg")
	else:
		$Item2.animation = "Empty"
		$Item3.animation = "Empty"
	if len(GlobalVars.kart.ourItems) > 2:
		$Item3.animation = GlobalVars.kart.ourItems[2]
	else:
		$Item3.animation = "Empty"
	
	
	
	#print(spending)
	if spending == "Ultra Recharge":
		$Lights.animation = "UltraRecharge"
	elif spending == "Big Recharge":
		$Lights.animation = "BigRecharge"
	elif spending == "Recharge":
		$Lights.animation = "Recharge"
	elif spending == "Balanced":
		$Lights.animation = "Balanced"
	elif spending == "Spend":
		$Lights.animation = "Spend"
	elif spending == "Big Spend":
		$Lights.animation = "BigSpend"
	elif spending == "Ultra Spend":
		$Lights.animation = "UltraSpend"
	
	$Timer.text = "Current Time: " + str(round_place(GlobalVars.kart.timer,3))
	$BestTime.text = "Best Time: " + str(round_place(GlobalVars.kart.bestTime,3))
	
	#Instead of using a if statement used this cool thing that speaks for itself
	$ResetText.visible = GlobalVars.kart.flipped
		
	
	
	
	
	$Laps.text = "Lap " + str(GlobalVars.kart.laps) + "/" + str(get_parent().maxLaps)
	
	$TireCondition.text = "Tire Condition: " + str(roundi(GlobalVars.kart.tireCondition*1000))
	$TireType.text = "Tire Type: " + str(GlobalVars.kart.tireType)
	$BatteryDisplay.text = "Battery: " + str(roundi(GlobalVars.kart.battery*100/GlobalVars.kart.maxBattery)) + "%"
	
	if GlobalVars.kart.inPit:
		$"Pit Condition".text = "In Pit\n(Use left and right arrows to switch tires)"
	else:
		$"Pit Condition".text = "Out Of Pit"


func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
