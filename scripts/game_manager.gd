extends Node

const SPRITES: Array[CompressedTexture2D] = [
	preload("res://assets/sprite.png"),
	preload("res://assets/sprite.png"),
	preload("res://assets/sprite.png"),
	preload("res://assets/sprite.png"),
	preload("res://assets/sprite.png"),
	preload("res://assets/sprite.png"),
	preload("res://assets/sprite.png")
]

const NUM_SPRITES: int = len(SPRITES)


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func get_new_type() -> int:
	return randi() % NUM_SPRITES
