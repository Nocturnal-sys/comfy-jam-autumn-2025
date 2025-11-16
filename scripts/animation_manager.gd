extends Node

const SPRITE: PackedScene = preload("res://scenes/vegetable_sprite.tscn")

signal swap_finished


func swap(a: Vegetable, b: Vegetable) -> void:
	create_sprite(a, b.global_position)
	create_sprite(b, a.global_position)


func create_sprite(vegetable: Vegetable, destination: Vector2) -> void:
	vegetable.set_disabled(true)

	var sprite = SPRITE.instantiate()
	sprite.set_texture(GameManager.SPRITES[vegetable.type])
	vegetable.add_child(sprite)

	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "global_position", destination, 0.25)
	tween.tween_callback(sprite.queue_free)

	await tween.finished
	vegetable.set_disabled(false)
	swap_finished.emit()
	
