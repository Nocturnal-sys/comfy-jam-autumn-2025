class_name Vegetable
extends TextureButton

var type: int


func _init() -> void:
	type = GameManager.get_new_type()
	set_texture_normal(GameManager.SPRITES[type])


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass
