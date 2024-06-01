extends Control

var time_menu = 0
var sound = false
var two_players_mode = false

func _ready():
	Global.js_show_ad()
	
func _notification(what):
	match what:
		MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			AudioServer.set_bus_mute(0,true)
		MainLoop.NOTIFICATION_WM_FOCUS_IN:
			AudioServer.set_bus_mute(0,false)

func _process(delta):
	time_menu +=  int(time_menu + delta) % 60
	if time_menu % 1000 == 0:
		$UI/description.self_modulate = Color(randi()%24,randi()%24,randi()%24,randi()%24)
func OneBtn_pressed():
	$ParallaxBackground.visible = false
	$UI.visible = false
	two_players_mode = false
	$audio_menu.playing = false
	var level: Node = ResourceLoader.load("res://Level/Level.tscn").instance()
	get_tree().root.add_child(level)
	if sound:
		get_tree().root.get_node("Level/audio_level").playing = true
		get_tree().root.get_node("Level/audio_level").autoplay = true
func TwoBtn_pressed():
	$ParallaxBackground.visible = false
	$UI.visible = false
	two_players_mode = true
	$audio_menu.playing = false
	var level: Node = ResourceLoader.load("res://Level/Level.tscn").instance()
	get_tree().root.add_child(level)
	if sound:
		get_tree().root.get_node("Level/audio_level").playing = true
		get_tree().root.get_node("Level/audio_level").autoplay = true
		
func soundButton_pressed():
	if sound:
		sound = false
		$UI/soundButton.normal = load("res://UI/buttons/no_musicBtn.png")
		$audio_menu.playing = false
	else:
		sound = true
		$UI/soundButton.normal = load("res://UI/buttons/musicBtn.png")
		$audio_menu.playing = true
