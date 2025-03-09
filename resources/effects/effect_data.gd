extends Resource
class_name Effect

enum Parameter {
	HP,
	MP,
	ATTACK,
	DEFENSE,
	SPEED,
}

enum CombatTarget {
	SINGLE,
	ZONE,
	ALL,
}

@export var name: String
@export var value: int
@export var target_parameter: Parameter
@export var combat_target: CombatTarget
