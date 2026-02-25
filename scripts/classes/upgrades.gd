#extends Node

# class_name Upgrade

# var text: String
# var cost: int
# var level: int
# var value: float # The value of whatever the upgrade is for
# var level_modifier: float # How levelling up affects the value
# var positive_mod: bool # Whether the levelling modifier positively or negatively affects the value

# func _purchase() -> void:
# 	if Global.cash >= cost:
# 		Global.cash -= cost
# 		var price_hike = round(cost * 0.2)
# 		cost += price_hike
# 		if positive_mod:
# 			value = value * level_modifier
# 		else:
# 			value = value / level_modifier
# 		level += 1
