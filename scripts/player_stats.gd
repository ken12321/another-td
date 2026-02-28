extends Node

signal credits_changed(new_amount: int)
signal wave_changed(new_wave: int)

signal base_damaged(damage: int)
signal base_destroyed()

var credits: int = 1000: # todo figure out starting cash
	set(value):
		credits = value
		credits_changed.emit(credits)

var current_wave: int = 1:
	set(value):
		current_wave = value
		wave_changed.emit(current_wave)

var base_health: int = 100:
	set(value):
		base_health = value
		if(base_health <= 0):
			base_destroyed.emit()

func add_credits(amount: int) -> void:
	credits += amount

func spend_credits(amount: int) -> bool:
	if (amount > credits):
		return false
	credits -= amount
	return true

func damage_base(amount: int):
	base_health -= amount
