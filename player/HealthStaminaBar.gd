extends Control

@export var hp_bar: TextureProgressBar
@export var stamina_bar: TextureProgressBar

var max_hp: int = 100
var max_stamina: int = 100
var hp: int = max_hp
var stamina: int = max_stamina
var stamina_regen_rate: float = 5.0  

func _ready():
	_update_bars()
	
func _process(delta):
	# Stamina regeneráció
	if stamina < max_stamina:
		stamina += stamina_regen_rate * delta
		stamina = min(stamina, max_stamina)
		_update_bars()

func take_damage(amount: int):
	hp -= amount
	hp = max(hp, 0)
	_update_bars()

func use_stamina(amount: int):
	stamina -= amount
	stamina = max(stamina, 0)
	_update_bars()

func _update_bars():
	if hp_bar:
		hp_bar.value = hp
	if stamina_bar:
		stamina_bar.value = stamina
