extends Node2D

var countTo_lose1 = 0; var countTo_lose2 = 0; #Счетчик касаний головой, если == 3, то проиграл.
var is_valid1 = false; var is_valid2 = false;
var wrestlers;
var restart_game = false;
var timer = 0.0 #Переменная для задержки перед рестартом
var wrestlers_scene
var round_count = 1
var map_index = 0 #randi() % 5
func _ready():
	Engine.set_time_scale(1.0)
	$audio_level.pitch_scale = 1.0
	#Настройка точек карты
	var points = $map_0/Path2D.curve.get_baked_points()
	$map_0/CollisionPolygon2D.polygon = points
	$map_0/Polygon2D.polygon = points
	$map_0/BorderLine.points = points
	points = $map_1/Path2D.curve.get_baked_points()
	$map_1/CollisionPolygon2D.polygon = points
	$map_1/Polygon2D.polygon = points
	$map_1/BorderLine.points = points
	points = $map_2/Path2D.curve.get_baked_points()
	$map_2/CollisionPolygon2D.polygon = points
	$map_2/Polygon2D.polygon = points
	$map_2/BorderLine.points = points
	points = $map_3/Path2D.curve.get_baked_points()
	$map_3/CollisionPolygon2D.polygon = points
	$map_3/Polygon2D.polygon = points
	$map_3/BorderLine.points = points
	points = $map_4/Path2D.curve.get_baked_points()
	$map_4/CollisionPolygon2D.polygon = points
	$map_4/Polygon2D.polygon = points
	$map_4/BorderLine.points = points
	
	wrestlers_scene = load("res://Wrestlers/Wrestlers.tscn")
	wrestlers = wrestlers_scene.instance()
	wrestlers.position = Vector2(490,90)
	get_tree().root.get_node("Level").add_child(wrestlers)
	if !get_tree().root.get_node("Menu").two_players_mode:
		$UI/left_jumpBtn.visible = false

func menuBtn_pressed():
	Global.js_show_ad()
	get_tree().root.get_node("Menu/Camera2D").current = true
	get_tree().root.get_node("Menu/UI").visible = true
	get_tree().root.get_node("Menu").two_players_mode = false
	get_tree().root.get_node("Menu/ParallaxBackground").visible = true
	if get_tree().root.get_node("Menu").sound:
		get_tree().root.get_node("Menu/audio_menu").playing = true
	get_tree().root.remove_child($".")
func _process(delta):
	if $UI/BlueTextureProgress.value >= 75 or $UI/RedTextureProgress.value >= 75:
		if $UI/BlueTextureProgress.value >= 75:
			$UI/endGame/Label2.text = "Blue Win"
			$UI/endGame/Label2.self_modulate = Color(0,0,255)
		else:
			$UI/endGame/Label2.text = "Red Win"
			$UI/endGame/Label2.self_modulate = Color(255,0,0)
		$UI/endGame.visible = true
		$UI/resultRoundText.visible = false
		
	if !restart_game: 
		if wrestlers.head_touch1 or wrestlers.head_touch2:
			if wrestlers.head_touch1 and !is_valid1:
				countTo_lose1 += 1
				is_valid1 = true
			if wrestlers.head_touch2 and !is_valid2:
				countTo_lose2 += 1
				is_valid2 = true
		if !wrestlers.head_touch1 or !wrestlers.head_touch2:
			if !wrestlers.head_touch1 and is_valid1:
				is_valid1 = false
			if !wrestlers.head_touch2 and is_valid2:
				is_valid2 = false
		if countTo_lose1 >= 1:
			$UI/resultRoundText.visible = true
			$UI/resultRoundText.text = "Blue take Round: " + str(round_count)
			$UI/resultRoundText.self_modulate = Color("206ac9")
			round_count += 1
			countTo_lose1 = 0
			countTo_lose2 = 0
			$UI/BlueTextureProgress.value += 15
			restart_game = true
		if countTo_lose2 >= 1:
			$UI/resultRoundText.visible = true
			$UI/resultRoundText.text = "Red take Round: " + str(round_count)
			$UI/resultRoundText.self_modulate = Color("e72222")
			round_count += 1
			countTo_lose2 = 0
			countTo_lose1 = 0
			$UI/RedTextureProgress.value += 15
			restart_game = true
	else:
		Engine.set_time_scale(0.1)
		$audio_level.pitch_scale = 0.6
		timer += delta
		if timer < 0.5:
			return
		else:
			timer = 0.0
			Engine.set_time_scale(1.0)
			$audio_level.pitch_scale = 1.0
			$UI/resultRoundText.visible = false
			#Смена карт
			match map_index:
				0:
					$map_0.set_collision_layer_bit(0,false)
					$map_0.set_collision_mask_bit(0,false)
					$map_0.set_collision_mask_bit(1,false)
					$map_0.set_collision_mask_bit(2,false)
					$map_0.set_collision_mask_bit(3,false)
					$map_0.visible = false
				1:
					$map_1.set_collision_layer_bit(0,false)
					$map_1.set_collision_mask_bit(0,false)
					$map_1.set_collision_mask_bit(1,false)
					$map_1.set_collision_mask_bit(2,false)
					$map_1.set_collision_mask_bit(3,false)
					$map_1.visible = false
				2:
					$map_2.set_collision_layer_bit(0,false)
					$map_2.set_collision_mask_bit(0,false)
					$map_2.set_collision_mask_bit(1,false)
					$map_2.set_collision_mask_bit(2,false)
					$map_2.set_collision_mask_bit(3,false)
					$map_2.visible = false
				3:
					$map_3.set_collision_layer_bit(0,false)
					$map_3.set_collision_mask_bit(0,false)
					$map_3.set_collision_mask_bit(1,false)
					$map_3.set_collision_mask_bit(2,false)
					$map_3.set_collision_mask_bit(3,false)
					$map_3.visible = false
				4:
					$map_4.set_collision_layer_bit(0,false)
					$map_4.set_collision_mask_bit(0,false)
					$map_4.set_collision_mask_bit(1,false)
					$map_4.set_collision_mask_bit(2,false)
					$map_4.set_collision_mask_bit(3,false)
					$map_4.visible = false
			map_index = randi() % 5
			match map_index:
				0:
					$map_0.set_collision_layer_bit(0,true)
					$map_0.set_collision_mask_bit(0,true)
					$map_0.set_collision_mask_bit(1,true)
					$map_0.set_collision_mask_bit(2,true)
					$map_0.set_collision_mask_bit(3,true)
					$map_0.visible = true
				1:
					$map_1.set_collision_layer_bit(0,true)
					$map_1.set_collision_mask_bit(0,true)
					$map_1.set_collision_mask_bit(1,true)
					$map_1.set_collision_mask_bit(2,true)
					$map_1.set_collision_mask_bit(3,true)
					$map_1.visible = true
				2:
					$map_2.set_collision_layer_bit(0,true)
					$map_2.set_collision_mask_bit(0,true)
					$map_2.set_collision_mask_bit(1,true)
					$map_2.set_collision_mask_bit(2,true)
					$map_2.set_collision_mask_bit(3,true)
					$map_2.visible = true
				3:
					$map_3.set_collision_layer_bit(0,true)
					$map_3.set_collision_mask_bit(0,true)
					$map_3.set_collision_mask_bit(1,true)
					$map_3.set_collision_mask_bit(2,true)
					$map_3.set_collision_mask_bit(3,true)
					$map_3.visible = true
				4:
					$map_4.set_collision_layer_bit(0,true)
					$map_4.set_collision_mask_bit(0,true)
					$map_4.set_collision_mask_bit(1,true)
					$map_4.set_collision_mask_bit(2,true)
					$map_4.set_collision_mask_bit(3,true)
					$map_4.visible = true
				
			get_tree().root.get_node("Level").get_node(wrestlers.name).queue_free()
			wrestlers = wrestlers_scene.instance()
			wrestlers.position = Vector2(461,90)
			get_node(".").add_child(wrestlers)
			restart_game = false
			
func restartBtn_pressed():
	$UI/endGame.visible = false
	$UI/BlueTextureProgress.value = 0
	$UI/RedTextureProgress.value = 0
	round_count = 1
	get_tree().root.get_node("Level").get_node(wrestlers.name).queue_free()
	wrestlers = wrestlers_scene.instance()
	wrestlers.position = Vector2(461,90)
	get_node(".").add_child(wrestlers)
