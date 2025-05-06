extends Control
var spending = "balanced"

@onready var kart = get_parent().get_parent()
func _process(delta: float) -> void:
	if len(get_parent().get_parent().ourItems) > 0:
		$Item1.animation = get_parent().get_parent().ourItems[0]
	else:
		$Item1.animation = "Empty"
		$Item2.animation = "Empty"
		$Item3.animation = "Empty"
	if len(get_parent().get_parent().ourItems) > 1:
		$Item2.animation = get_parent().get_parent().ourItems[1]
		print("gg")
	else:
		$Item2.animation = "Empty"
		$Item3.animation = "Empty"
	if len(get_parent().get_parent().ourItems) > 2:
		$Item3.animation = get_parent().get_parent().ourItems[2]
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
	$Timer.text = "Current Time: " + str(round_place(get_parent().get_parent().timer,3))
	$BestTime.text = "Best Time: " + str(round_place(get_parent().get_parent().bestTime,3))
	
	#Instead of using a if statement used this cool thing that speaks for itself
	$ResetText.visible = get_parent().get_parent().flipped
		
	
	
	
	
	$Laps.text = "Lap " + str(get_parent().get_parent().laps) + "/" + str(get_parent().get_parent().get_parent().maxLaps)
	
	$TireCondition.text = "Tire Condition: " + str(roundi(get_parent().get_parent().tireCondition*1000))
	$TireType.text = "Tire Type: " + str(get_parent().get_parent().tireType)
	$BatteryDisplay.text = "Battery: " + str(roundi(get_parent().get_parent().battery*100/get_parent().get_parent().maxBattery)) + "%"
	
	if get_parent().get_parent().inPit:
		$"Pit Condition".text = "In Pit\n(Use left and right arrows to switch tires)"
	else:
		$"Pit Condition".text = "Out Of Pit"


func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
