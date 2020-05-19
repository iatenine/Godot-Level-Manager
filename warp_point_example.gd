extends Area2D

export (String) var PLAYER_NAME
export (int) var TARGET_SCENE  #Set to index of the scene you wish to load

func _ready():
	add_user_signal("switch_room", [TARGET_SCENE])

#Attach on_body_enter signal to this function
func _on_warp_point_body_entered(body):
	if(body.name == PLAYER_NAME):
		emit_signal("switch_room")
