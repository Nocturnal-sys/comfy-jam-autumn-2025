class_name Vegetable
extends TextureButton

var type: int

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


func _init() -> void:
	type = randi() % NUM_SPRITES
	set_texture_normal(SPRITES[type])


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass
