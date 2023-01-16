extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var atkbonus
var defbonus
var itemname
var itemtext
var hpbonus
var cleanup = false
var yielding = false
var tool_tip = preload("res://Tooltip.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func init(atk, def, iname, texture, hp):
	self.atkbonus = atk
	self.defbonus = def
	self.itemname = iname
	self.itemtext = texture
	self.hpbonus = hp
	var itemtexture = get_node("Item")
	#itemtexture.hint_tooltip = iname + str(atk) + str(def)
	itemtexture.set_texture(load(texture))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

"""
func _on_Item_mouse_entered():
	var tool_tip_instance = tool_tip.instance()
	self.add_child(tool_tip_instance)
	tool_tip_instance.init(itemname,atkbonus,defbonus,hpbonus)
	tool_tip_instance.popup_exclusive = true
	tool_tip_instance.rect_position = get_parent().get_global_position()
	yielding = true
	yield(get_tree().create_timer(0.35), "timeout")
	yielding = false
	if cleanup:
		self.queue_free()
	if has_node("Tooltip") and get_node("Tooltip").valid and tool_tip_instance != null:
		get_node("Tooltip").popup()


func _on_Item_mouse_exited():
	self.get_node("Tooltip").queue_free()
"""
