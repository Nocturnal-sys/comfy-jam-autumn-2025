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
const GRID_SIZE: int = 8

enum State {
	READY,
	SELECTED,
	WAITING
}

var current_state: State = State.WAITING
var selected_index: int = -1
var highlighted: Array[int] = []

signal swap_ready(a: int, b: int)


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func get_new_type() -> int:
	return randi() % NUM_SPRITES


func swap(index: int) -> void:
	if selected_index < 0 or index < 0:
		return

	swap_ready.emit(selected_index, index)


func set_ready() -> void:
	current_state = State.READY
	selected_index = -1
	highlighted = []


func set_selected(vegetable: Vegetable) -> void:
	current_state = State.SELECTED
	selected_index = vegetable.index
	highlighted = vegetable.adjacent.duplicate()


func set_waiting() -> void:
	current_state = State.WAITING
