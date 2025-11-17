extends Node

const SPRITE: PackedScene = preload("res://scenes/vegetable_sprite.tscn")
const SPEED: float = 0.25

signal swap_finished


func create_sprite(vegetable: Vegetable, destination: Vector2) -> Tween:
	var sprite: Sprite2D = SPRITE.instantiate()
	sprite.set_texture(GameManager.SPRITES[vegetable.type])
	vegetable.add_child(sprite)

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "global_position", destination, SPEED)
	tween.tween_callback(sprite.queue_free)

	return tween


func swap(a: Vegetable, b: Vegetable) -> void:
	var vegetables: Array[Vegetable] = [a, b]

	for vegetable in vegetables:
		vegetable.set_disabled(true)

	var tween: Tween = create_sprite(a, b.global_position)
	create_sprite(b, a.global_position)

	await tween.finished

	var temp: int = a.type
	a.update_type(b.type)
	b.update_type(temp)

	for vegetable in vegetables:
		vegetable.set_disabled(false)

	swap_finished.emit()
