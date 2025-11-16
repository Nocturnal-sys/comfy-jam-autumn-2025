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
	WAITING,
	READY,
	SELECTED
}

var current_state: State = State.WAITING
var selected_index: int = -1
var selected_type: int = -1
var highlighted: Array[int] = []


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func get_new_type() -> int:
	return randi() % NUM_SPRITES


func set_waiting() -> void:
	current_state = State.WAITING
	reset_selected()


func set_ready() -> void:
	current_state = State.READY
	reset_selected()


func set_selected(vegetable: Vegetable) -> void:
	current_state = State.SELECTED
	selected_index = vegetable.index
	selected_type = vegetable.type
	highlighted = vegetable.adjacent.duplicate()


func reset_selected() -> void:
	selected_index = -1
	selected_type = -1
	highlighted = []
