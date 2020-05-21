# Godot-Level-Manager
Designed to store, switch between and maintain statefulness between all the scenes of your game

# How to Use

## Level Management
 * Attach level_manager.gd to the root node of a(n ideally empty) scene in your game and set it to the "Main Scene" in Project Settings -> General -> Run if not already
 * Resize the world array to fit the PackedScenes you'd like to use in the game
 * Add any PackedScenes you'd like to instance in the game
 * Set the curr_scene to the index of the scene you'd like to be loaded at the start of the game

## Implementing passages
To create a passageway, simply create an item that emits the signal specified in the signal_name with a parameter of the index of the scene you'd like to load (as it was entered in the world array above)

example:
    func _ready():
	      add_user_signal("switch_room", [TARGET_SCENE])

NOTE: Adding a signal implicitly has been known to cause bugs, it is **highly recommended** to use the add_user_signal() function in your dooors, hallways, warp points, etc

## State Management
If you'd like an object to maintain its state upon returning to a scene, add it to a group that shares the name specified by the stateful_group_name variable. By default this will only save user-defined variables unless you've set the deep_save flag to true (uses lots of memory, not recommended in most cases)

