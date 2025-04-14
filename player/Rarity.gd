extends Resource
class_name Rarity

enum RarityLevel { COMMON, RARE, EPIC, LEGENDARY }

static func get_bonus_multiplier(rarity: RarityLevel) -> float:
	match rarity:
		RarityLevel.COMMON: return 1.1
		RarityLevel.RARE: return 1.25
		RarityLevel.EPIC: return 1.5
		RarityLevel.LEGENDARY: return 2.0
	return 1.0
