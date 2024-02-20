class_name Player
extends CharacterBody2D

signal island_reached(island: Island)

enum State {MOVING, IDLE}

@export var speed := 150.0

var state := State.IDLE
var path: Array = []
var target_island: Island = null

@onready var navigation_agent := $NavigationAgent2D as NavigationAgent2D

func _process(_delta: float) -> void:
	if not path.is_empty() and abs(path[0].x - global_position.x) < 5 and abs(path[0].y - global_position.y) < 5:
		path.pop_front()
	
	if path.is_empty() and state != State.IDLE:
		state = State.IDLE
		await target_island.player_enter(self)
		island_reached.emit(target_island);
	
	match state:
		State.MOVING:
			var direction := global_position.direction_to(path[0])
			velocity = direction * speed
			move_and_slide()


func move_to_island(island: Island) -> void:
	if  path.is_empty() and state == State.IDLE and can_move_to_island(island):
		if target_island != null:
			await target_island.player_exit(self)
		
		target_island = island
		navigation_agent.target_position = island.target_position
		navigation_agent.get_next_path_position()
		path = Array(navigation_agent.get_current_navigation_path())
		state = State.MOVING


func can_move_to_island(island: Island) -> bool:
	var current_target_position := navigation_agent.target_position
	navigation_agent.target_position = island.target_position
	var is_reachable = navigation_agent.is_target_reachable()
	navigation_agent.target_position = current_target_position
	return is_reachable
