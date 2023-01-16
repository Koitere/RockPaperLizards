extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var typeselect = load("res://PlayerSelect.tscn").instance()
var battledraw = load("res://BattleDraw.tscn").instance()
const BasePlayer := preload("res://Player.tscn")
var Nameinput
var Player
var P1Panel
var P2Panel
var RoundLabel
var ResultText
var AdvanceButton
var ResetButton
var shop
var livesdisplay
var winstext
var rng
var ItemShop = preload("res://Shop.tscn")
var fullheart = preload("res://health.png")
var emptyheart = preload("res://healthempty.png")
var titlescreen
signal restart
var recordkeys = []
var opponent_data = {}
var opponent_search
var ingame
# Called when the node enters the scene tree for the first time.
func _ready():
	typeselect.visible = false
	battledraw.visible = false
	ingame = false
	get_node("../Node2D").add_child(typeselect)
	get_node("../Node2D/DrawLoc").add_child(battledraw)
	P1Panel = get_node("../Node2D/P1Panel")
	P2Panel = get_node("../Node2D/P2Panel")
	RoundLabel = get_node("../Node2D/RoundLabel")
	ResultText = get_node("../Node2D/ResultText")
	livesdisplay = [get_node("../Node2D/GameStats/HBoxContainer/Lives"),get_node("../Node2D/GameStats/HBoxContainer/Lives2"),get_node("../Node2D/GameStats/HBoxContainer/Lives3")]
	AdvanceButton = get_node("../Node2D/AdvanceButton")
	AdvanceButton.connect("pressed", self, "advanceround")
	ResetButton = get_node("../Node2D/NewGameButton")
	ResetButton.connect("pressed",self, "restart_select")
	winstext = get_node("../Node2D/GameStats/WinsCount")
	Nameinput = get_node("../Node2D/NameInput")
	opponent_search = get_node("../Node2D/OpponentSearch")
	titlescreen = get_node("../Node2D/TitleScreen")
	shop = ItemShop.instance()
	get_node("../Node2D").add_child(shop)
	shop.visible = false
	########
	#GAMEJOLT API CREDENTIALS GO HERE
	########

	get_keys()
	
func _on_set_data_request_completed(data: Array):
	if data[0]['success'] == 'true':
		print("Match data updated successfully")
	
func _on_get_keys_request_completed(data: Array):
	if data[0]['success'] == 'true':
		recordkeys = []
		for k in data[0]['keys']:
			recordkeys.append(str(k['key']))
		print("Keys Updated Successfully")

		
func _on_get_data_request_completed(data: Array, datakey):
	if data[0]['success'] == 'true':
		var record_data = data[0]['data']
		opponent_data[datakey] = parse_json(record_data)
		print(datakey, " data successfully obtained")

func get_keys():
	var get_record_keys = GameJoltAPI.create_request("/data-store/get-keys/",{
	})
	get_record_keys.connect("api_request_completed",self, "_on_get_keys_request_completed")
	yield(get_record_keys, "api_request_completed")

func submit_battle_data(recstring):
	var set_opponent_request = GameJoltAPI.create_request("/data-store/set/",{
		"key": recstring,
		"data": to_json(opponent_data[recstring])
	})
	set_opponent_request.connect("api_request_completed",self,"_on_set_data_request_completed")
	
func request_opponent_data(recstring):
	var get_opponent_request = GameJoltAPI.create_request("/data-store/",{
		"key":recstring
	})
	get_opponent_request.connect("api_request_completed",self,"_on_get_data_request_completed", [recstring])
	yield(get_opponent_request, "api_request_completed")

func game_start(player):
	var types = ['Fire','Water','Grass']
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var lives = 3
	var wins = 0
	var items = 0
	P1Panel.update_stats(player, player.type, -1)
	if player.pname == "grande":
		get_node("../Node2D/P1Title").visible = true
	else:
		get_node("../Node2D/P1Title").visible = false
	for x in range(3):
		livesdisplay[x].texture = emptyheart
	for x in range(lives):
		livesdisplay[x].texture = fullheart
	winstext.text = str(wins)
	while lives > 0:
		var p2
		opponent_search.visible = true
		opponent_search.get_node("AnimatedSprite").frame = 0
		player.get_node("AnimationPlayer/Player").visible = false
		opponent_search.get_node("RichTextLabel").text = "Searching For Opponent.."
		opponent_search.get_node("AnimatedSprite").frames.set_animation_loop("default",true)
		opponent_search.get_node("AnimatedSprite").play("default")
		if wins != 0 or lives != 3:
			yield(get_keys(), "completed")
			var recstring = str(wins) + "_" + str(lives)
			var stats = [player.attack[0],player.attack[1],player.attack[2],player.defence[0],player.defence[1],player.defence[2],player.hp,player.type,player.pname]
			if recstring in recordkeys:
				yield(request_opponent_data(recstring), "completed")
				if recstring in opponent_data:
					var opp = opponent_data[recstring].keys()
					opp = opponent_data[recstring][opp[rng.randi_range(0,len(opp)-1)]]
					p2 = create_player(opp[7], opp[8], opp)
					opponent_data[recstring][player.pname + "_" + str(len(opponent_data[recstring].keys()))] = stats
					submit_battle_data(recstring)
				else: #get opponent data must have failed, just go with random opponent and don't submit this data (don't want to overwrite)
					p2 = create_player(types[rng.randi_range(0,2)], "Opponent", null)
					for x in range(items):
						p2.upgrade(shop.generate())
						if x % 2 == 0:
							p2.hp += 1
			else:
				opponent_data[recstring] = {
					player.pname + "_" + str(0):stats
				}
				p2 = create_player(types[rng.randi_range(0,2)], "Opponent", null)
				for x in range(items):
					p2.upgrade(shop.generate())
					if x % 2 == 0:
						p2.hp += 1
				submit_battle_data(recstring)
		else:
			p2 = create_player(types[rng.randi_range(0,2)], "Opponent", null)
			
			
		p2.get_node("AnimationPlayer/Player").visible = false
		opponent_search.get_node("AnimatedSprite").stop()
		opponent_search.get_node("AnimatedSprite").frames.set_animation_loop("default",false)
		opponent_search.get_node("AnimatedSprite").play("default")
		yield(opponent_search.get_node("AnimatedSprite"), "animation_finished")
		opponent_search.get_node("AnimatedSprite").stop()
		opponent_search.get_node("RichTextLabel").text = "Opponent Found!"
		opponent_search.get_node("AnimatedSprite").frame = (p2.type * 2) + 1
		yield(get_tree().create_timer(2), "timeout")
		opponent_search.visible = false
		
		
		player.get_node("AnimationPlayer/Player").visible = true
		p2.get_node("AnimationPlayer/Player").visible = true
		P1Panel.update_stats(player, player.type, p2.type)
		P2Panel.update_stats(p2, p2.type, player.type)
		var res = yield(fight(player,p2,lives), "completed")
		lives = res[0]
		if res[1]:
			wins += 1
		for x in range(3):
			livesdisplay[x].texture = emptyheart
		for x in range(lives):
			livesdisplay[x].texture = fullheart
		winstext.text = str(wins)
		yield(AdvanceButton, "pressed")
		player.hp += 1
		battledraw.queue_free()
		battledraw = load("res://BattleDraw.tscn").instance()
		get_node("../Node2D/DrawLoc").add_child(battledraw)
		battledraw.visible = false
		player.get_node("AnimationPlayer/Player").visible = true
		p2.get_node("AnimationPlayer/Player").visible = true
		P2Panel.update_stats(p2,p2.type,-1)
		P2Panel.clear_panel()
		if lives == 0:
			ResultText.text = 'GAME OVER. WINS: ' + str(wins)
			p2.queue_free()
			break
		player.get_node("AnimationPlayer/Player").position = Vector2(512,360)
		p2.queue_free()
		shop.visible = true
		P1Panel.update_stats(player,player.type, -1)
		shop.make_shop()
		var i1 = yield(shop, "itemselect")
		player.upgrade(i1)
		items += 1
		P1Panel.update_stats(player,player.type, -1)
		shop.clean_shop()
		shop.make_shop()
		var i2 = yield(shop, "itemselect")
		player.upgrade(i2)
		items += 1
		P1Panel.update_stats(player,player.type, -1)
		shop.clean_shop()
		shop.visible = false
		player.get_node("AnimationPlayer/Player").position = Vector2(512,290)
		player.get_node('AnimationPlayer/Player/ProgressBar').value = 100
		ResultText.text = ''
	player.get_node("AnimationPlayer/Player").position = Vector2(512,300)
	ResetButton.visible = true
	
	

func fight(player1, player2, lives):
	player1.get_child(0).play("Battle Animation")
	player2.get_child(0).play("Battle Animation Rev")
	yield( player2.get_child(0), "animation_finished")
	ResultText.text = ''
	var roundnum = 0
	var atkmult = 1.5
	var defmult = 0.5
	var p1hp = player1.hp
	var p2hp = player2.hp
	var pwin = false
	while p1hp > 0 and p2hp > 0:
		roundnum += 1
		RoundLabel.text = "ROUND: " + str(roundnum)
		player1.get_child(0).play("Fight")
		player2.get_child(0).play("Fight Rev")
		yield( player2.get_child(0), "animation_finished")
		p1hp -= max((player2.attack[player1.type]*atkmult) - (player1.defence[player2.type] * defmult),1)
		p2hp -= max((player1.attack[player2.type]*atkmult) - (player2.defence[player1.type] * defmult),1)
		player1.get_node('AnimationPlayer/Player/ProgressBar').value -= max((player2.attack[player1.type]*atkmult) - (player1.defence[player2.type] * defmult),1) * (10.0 * (10.0/player1.hp))
		player2.get_node('AnimationPlayer/Player/ProgressBar').value -= max((player1.attack[player2.type]*atkmult) - (player2.defence[player1.type] * defmult),1) * (10.0 * (10.0/player2.hp))
	if p1hp > 0:
		ResultText.text = player1.pname + " Wins"
		pwin = true
	elif p2hp > 0:
		ResultText.text = player2.pname + " Wins"
		lives -= 1
	else:
		#BATTLE IS A DRAW
		if player1.pname == 'Gsuz':
			ResultText.text = "DISHONORABLE LOSS"
			lives -= 1
			AdvanceButton.visible = true
			return [lives,pwin]
		battledraw.visible = true
		var drawresult = yield(battledraw.resolve_draw(player1,player2,lives), "completed")
		pwin = drawresult[0]
		lives = drawresult[1]

	AdvanceButton.visible = true
	return [lives, pwin]

func create_player(type,pname,stats):
	var player = BasePlayer.instance().init(type,pname,stats)
	get_node("../Node2D").add_child(player)
	return player

func _process(_delta):
	if ingame and Input.is_action_just_pressed("ui_accept") and Nameinput.get_text() != '':
		if typeselect.selected != '':
			typeselect.visible = false
			var p1 = create_player(typeselect.selected, Nameinput.get_text(),null)
			typeselect.selected = ''
			Nameinput.visible = false
			game_start(p1)
			yield(self,"restart")
			p1.queue_free()
			ResultText.text = ''
			ingame = false
			get_node("../Node2D/TitleScreen").visible = true

func advanceround():
	AdvanceButton.visible = false
	
func restart_select():
	ResetButton.visible = false
	emit_signal("restart")
