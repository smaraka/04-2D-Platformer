extends Node


var save_data = {
	"level":1
	,"score":0
	,"timer":0
}

var levels = [
	load("res://Scene/Level1.tscn")
	,load("res://Scene/Level2.tscn")
]

var level = 1
var score = 0
var timer = 0

const save_file = "user://save.dat"
const key = "C220 Is the Best!"
#var save_file = ConfigFile.new()

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		var menu = get_node_or_null("/root/Game/UI/Menu")
		if menu != null:
			if not menu.visible:
				menu.show()
				get_tree().paused = true
			else:
				menu.hide()
				get_tree().paused = false

func increase_score(s):
	save_data["score"] += s
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_score()

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass(save_file, File.WRITE, key)
	#save_game.store_string()
	save_game.store_line(to_json(save_data))
	
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_data():
	var save_game = File.new()

	save_game.open_encrypted_with_pass(save_file, File.READ, key)

	parse_json(save_game.get_line())
	increase_score(0)
	
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		node.queue_free()
	
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line()) 
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save_game.close()
	get_tree().paused = false

func load_game():
	var save_game = File.new()
	if not save_game.file_exists(save_file):
		return # Error! We don't have a save to load.
	save_game.open_encrypted_with_pass(save_file, File.READ, key)

		
	save_data = parse_json(save_game.get_line())
	save_game.close()
	var _scene = get_tree().change_scene_to(levels[save_data["level"] - 1])
	call_deferred("load_data")

