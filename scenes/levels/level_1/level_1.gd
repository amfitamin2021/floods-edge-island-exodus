extends Level

var counter := 0
var is_education_open := true

@onready var healing_island := $Islands/HealingIsland2 as Island
@onready var hostile_island := $Islands/HostileIsland2 as Island
@onready var resource_island := $Islands/ResourceIsland2 as Island


@onready var label1 := $Education/Control/PanelContainer/MarginContainer/Label as Label
@onready var label2 := $Education/Control/PanelContainer/MarginContainer/Label2 as Label
@onready var label3 := $Education/Control/PanelContainer/MarginContainer/HungerBar/Label3 as Label
@onready var label4 := $Education/Control/PanelContainer/MarginContainer/ToolsMenu/Label4 as Label
@onready var label5 := $Education/Control/PanelContainer/MarginContainer/IslandHint/Label5 as Label
@onready var label6 := $Education/Control/PanelContainer/MarginContainer/IslandHint/Label6 as Label
@onready var label7 := $Education/Control/PanelContainer/MarginContainer/IslandHint/Label7 as Label


@onready var hint3 := $Hints/Select as PointLight2D
@onready var hint4 := $Hints/PointLight2D2 as PointLight2D
@onready var hintIsland := $Education/Control/PanelContainer/MarginContainer/Control/PointLight2D3 as PointLight2D

@onready var education := $Education as CanvasLayer


func _ready():
	super._ready()
	hide_education()
	for island in islands_container.get_children() as Array[Island]:
		island.island_entered.connect(on_island_entered)
	
	is_game_on_pause = true
	education.show()
	label1.show()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action") and is_education_open:
		counter +=1
		
		if counter == 1:
			label1.hide()
			
			label2.show()
			
		elif counter == 2:
			label2.hide()
			
			label3.show()
			hint3.show()
			
		elif counter == 3:
			label3.hide()
			hint3.hide()
			
			label4.show()
			hint4.show()
		else:
			is_education_open = false
			hide_education()


func hide_education() -> void:
	is_game_on_pause = false
	
	education.hide()
	label1.hide()
	label2.hide()
	
	label3.hide()
	hint3.hide()
	
	label4.hide()
	hint4.hide()
	
	label5.hide()
	label6.hide()
	label7.hide()
	hintIsland.hide()


func on_island_entered(island: Island) -> void:
	if island.is_first_visit:
		match island:
			healing_island:
				education.show()
				label6.show()
				hintIsland.show()
				is_education_open = true
				is_game_on_pause = true
			hostile_island:
				education.show()
				label5.show()
				hintIsland.show()
				is_education_open = true
				is_game_on_pause = true
			resource_island:
				education.show()
				label7.show()
				hintIsland.show()
				is_education_open = true
				is_game_on_pause = true


func end_game(is_win: bool) -> void:
	hide_education()
	super.end_game(is_win)
