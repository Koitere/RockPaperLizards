extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var type
var typename
var attack
var defence
var hp
var pname
var fire_text = preload("res://firelizanim.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(etype, npname,stats):
	if stats != null:
		self.attack = [int(stats[0]),int(stats[1]),int(stats[2])]
		self.defence = [int(stats[3]),int(stats[4]),int(stats[5])]
		self.hp = int(stats[6])
		self.type = int(stats[7])
	else:
		if etype == 'Fire':
			self.attack = [0,0,1]
			self.defence = [0,-1,1]
			self.type = 0
			self.typename = etype
		elif etype == 'Water':
			self.attack = [1,0,0]
			self.defence = [1,0,-1]
			self.type = 1
			self.typename = etype
		else:
			self.attack = [0,1,0]
			self.defence = [-1,1,0]
			self.type = 2
			self.typename = etype
		self.hp = 10
	self.pname = npname
	if self.type == 0:
		get_node("AnimationPlayer/Player").play("fire")
	elif self.type == 1:
		get_node("AnimationPlayer/Player").play("water")
	else:
		get_node("AnimationPlayer/Player").play("grass")
	return self

func upgrade(item):
	if item:
		for x in range(3):
			self.attack[x] += item.atkbonus[x]
			self.defence[x] += item.defbonus[x]
		self.hp += item.hpbonus

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
