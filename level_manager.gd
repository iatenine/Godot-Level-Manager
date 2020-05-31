tool
extends Node

export (Array, PackedScene) var world
export(String) var stateful_group_name = "stateful"
export(String) var signal_name = "switch_room"
export(int) var curr_scene = 0

var active_root:Node
var scene_states = []

func _ready():
	active_root = world[curr_scene].instance()
	add_child(active_root)
	scene_states.resize(world.size())
	_connect_signals()

func _change_room(target_idx:int) -> int:
	if(target_idx < 0 or target_idx >= world.size()):
		return ERR_INVALID_PARAMETER
	call_deferred("_update_room", target_idx)
	return OK

func _connect_signals() -> void:
	for x in active_root.get_children():
		if(x.has_user_signal(signal_name) == true):
			x.connect(signal_name, self, "_change_room", [x.TARGET_SCENE])

func _update_room(idx:int):
	_save_state()
	curr_scene = idx
	remove_child(active_root)
	active_root.queue_free()
	active_root = world[idx].instance()
	add_child(active_root)
	_connect_signals()
	_load_state(idx)

func _save_state(deep:bool = false):
	scene_states[curr_scene] = []
	
	for x in active_root.get_children():
		if(x.is_in_group(stateful_group_name)):
			var begin = 0
			var end = x.get_property_list().size()
			if(deep == false):
				begin = 14
			for i in range(begin, end):
				var new_key = x.get_property_list()[i]["name"]
				var new_val = x.get(new_key)
				scene_states[curr_scene].append({new_key:new_val})

func _load_state(scene_idx:int, deep:bool = false) -> void:
	var curr_dict = scene_states[scene_idx]
	if(typeof(curr_dict) != TYPE_ARRAY):
		return
	
	var prop_range = 0
	var ignore = 0
	var count = 0
	if(deep == false):
		ignore = 61
	
	for x in active_root.get_children():
		if(x.is_in_group(stateful_group_name)):
			prop_range = x.get_property_list().size() - ignore
			for _val in range(0, prop_range):
				x.set(curr_dict[count].keys()[0], curr_dict[count].values()[0])
				count+=1
