extends Resource
class_name Upgrade

@export var name: String
@export var rarity: Rarity.RarityLevel
@export_enum("health", "stamina", "stamina_regen", "stamina_drain", "damage", "rpm", "bullet_speed", "accuracy") var stat_to_upgrade: String
@export var flat_bonus: float = 0.0
@export var percent_bonus: float = 0.0

func apply_to_character(stats: CharacterStats) -> void:
	match stat_to_upgrade:
		"health":
			stats.max_hp += flat_bonus + stats.max_hp * percent_bonus
		"stamina":
			stats.max_stamina += flat_bonus + stats.max_stamina * percent_bonus
		"stamina_regen":
			stats.stamina_regen_rate += flat_bonus + stats.stamina_regen_rate * percent_bonus
		"stamina_drain":
			stats.stamina_drain_rate -= flat_bonus + stats.stamina_drain_rate * percent_bonus

func apply_to_weapon(stats: WeaponStats) -> void:
	match stat_to_upgrade:
		"damage":
			stats.damage += flat_bonus + stats.damage * percent_bonus
		"rpm":
			stats.rpm += flat_bonus + stats.rpm * percent_bonus
		"bullet_speed":
			stats.bullet_speed += flat_bonus + stats.bullet_speed * percent_bonus
		"accuracy":
			stats.accuracy += flat_bonus + stats.accuracy * percent_bonus
