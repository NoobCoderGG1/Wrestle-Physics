extends RigidBody2D

var jumpPressed_1 = false;	var jumpPressed_2 = false #Удержание кнопки прыжка
var desangle_hip1_sitting = -1.5;	var desangle_hip2_sitting = 1.5; #Угол к которому стремимся в состоянии присяди
var desangle_hip1_jump = 0;	var desangle_hip2_jump = 0; #Угол к которому стремимся в состоянии стоя
var desangle_leg1_jump = 0;	var desangle_leg2_jump = 0;
var desangle_leg1_sitting = -0.5;	var desangle_leg2_sitting = 0.5;
var desangle_foot1_jump = 0.5;	var desangle_foot2_jump = -0.5;
var desangle_foot1_sitting = 0;	var desangle_foot2_sitting = 0;
var on_ground_1 = false; var on_ground_2 = false; #Проверка нахождения на земле
var reload_jump1 = 1; var reload_jump2 = 1; #Перезарядка прыжка
var head_touch1 = false; var head_touch2 = false; #Проверка на касание головы о землю

var bot_timer_jump = 0.0 #Для бота, чтобы долго не стоял, прыгал 
var bot_timer_sit = 0.0
func _physics_process(delta):
	$Bodies1/Arm1.angular_velocity = clamp($Bodies1/Hand1.angular_velocity,$Bodies1/Arm1.angular_velocity - 25, $Bodies1/Arm1.angular_velocity + 25)
	$Bodies2/Arm2.angular_velocity = clamp($Bodies2/Hand2.angular_velocity,$Bodies2/Arm2.angular_velocity - 25, $Bodies2/Arm2.angular_velocity + 25)
	$Bodies1/Head1.angular_velocity = $Bodies1/Body1.angular_velocity
	$Bodies2/Head2.angular_velocity = $Bodies2/Body2.angular_velocity
	if !get_tree().root.get_node("Menu").two_players_mode:
		if jumpPressed_2 or bot_timer_jump <= 1.5:
			Input.action_press("jump1")
			bot_timer_jump += delta
			bot_timer_sit = 0.0
		elif bot_timer_jump >= 1.5:
			Input.action_release("jump1")
			bot_timer_sit += delta
			if bot_timer_sit >= 1.5:
				bot_timer_jump = 0.0
			
		
	#Player_1
	#Если нажали или удерживают
	if (Input.is_action_just_pressed("jump1") or jumpPressed_1):
		if !jumpPressed_1 and on_ground_1 and reload_jump1 >= 1.0: #Импульс производится только при нажатии, а не удержании
			$Bodies1/Body1.apply_central_impulse(Vector2(1,-1) * 2000)
		else:
			var current_degrees = $Bodies1/Hip1.get_global_transform().get_rotation()
			$Bodies1/Hip1.angular_velocity = lerp(current_degrees, desangle_hip1_jump, 900 * delta) #Устанавливаем нужную скорость для вращения по оси для плавного возвращения в нужное положение; lerp(текущий угол, угол к которому стремится, скорость выполнения)
			current_degrees = $Bodies1/Leg1.get_global_transform().get_rotation()
			$Bodies1/Leg1.angular_velocity = lerp(current_degrees, desangle_leg1_jump, 300 * delta)
			current_degrees = $Bodies1/Foot1.get_global_transform().get_rotation()
			$Bodies1/Foot1.angular_velocity = lerp(current_degrees, desangle_foot1_jump, 300 * delta)
		jumpPressed_1 = true
	#Если отпустили кнопку
	if Input.is_action_just_released("jump1") or !jumpPressed_1:
		if jumpPressed_1:
			reload_jump1 = 0.0
		var current_degrees = $Bodies1/Hip1.get_global_transform().get_rotation()
		$Bodies1/Hip1.angular_velocity = lerp(current_degrees, desangle_hip1_sitting, 300 * delta)
		current_degrees = $Bodies1/Leg1.get_global_transform().get_rotation()
		$Bodies1/Leg1.angular_velocity = lerp(current_degrees, desangle_leg1_sitting, 300 * delta)
		current_degrees = $Bodies1/Foot1.get_global_transform().get_rotation()
		$Bodies1/Foot1.angular_velocity = lerp(current_degrees, desangle_foot1_sitting, 300 * delta)
		jumpPressed_1 = false
		reload_jump1 += delta
	#Player_2
	if (Input.is_action_just_pressed("jump2") or jumpPressed_2):
		if !jumpPressed_2 and on_ground_2 and reload_jump2 >= 1.0: #Импульс производится только при нажатии, а не удержании
			$Bodies2/Body2.apply_central_impulse(Vector2(-1,-1) * 2000)
		else:
			var current_degrees = $Bodies2/Hip2.get_global_transform().get_rotation()
			$Bodies2/Hip2.angular_velocity = lerp(current_degrees, desangle_hip2_jump, 900 * delta) #Устанавливаем нужную скорость для вращения по оси для плавного возвращения в нужное положение; lerp(текущий угол, угол к которому стремится, скорость выполнения)
			current_degrees = $Bodies2/Leg2.get_global_transform().get_rotation()
			$Bodies2/Leg2.angular_velocity = lerp(current_degrees, desangle_leg2_jump, 300 * delta)
			current_degrees = $Bodies2/Foot2.get_global_transform().get_rotation()
			$Bodies2/Foot2.angular_velocity = lerp(current_degrees, desangle_foot2_jump, 300 * delta)
		jumpPressed_2 = true
	#Если отпустили кнопку
	if Input.is_action_just_released("jump2") or !jumpPressed_2:
		if jumpPressed_2:
			reload_jump2 = 0.0
		var current_degrees = $Bodies2/Hip2.get_global_transform().get_rotation()
		$Bodies2/Hip2.angular_velocity = lerp(current_degrees, desangle_hip2_sitting, 300 * delta)
		current_degrees = $Bodies2/Leg2.get_global_transform().get_rotation()
		$Bodies2/Leg2.angular_velocity = lerp(current_degrees, desangle_leg2_sitting, 300 * delta)
		current_degrees = $Bodies2/Foot2.get_global_transform().get_rotation()
		$Bodies2/Foot2.angular_velocity = lerp(current_degrees, desangle_foot2_sitting, 300 * delta)
		jumpPressed_2 = false
		reload_jump2 += delta 
		
func ground_entered_player1(body):
	on_ground_1 = true
func ground_entered_player2(body):
	on_ground_2 = true
func ground_exited_player1(body):
	on_ground_1 = false
func ground_exited_player2(body):
	on_ground_2 = false

func head1_touch(body):
	if body is StaticBody2D:
		head_touch1 = true
		$head_touch_sound.play(0.48)
func head1_untouched(body):
	head_touch1 = false
func head2_touch(body):
	if body is StaticBody2D:
		head_touch2 = true
		$head_touch_sound.play(0.48)
func head2_untouched(body):
	head_touch2 = false

#----------------------
#1. Добавить удержание leg с помощью lerp(полная фиксация положения ног), либо clamp (без фиксации, но ноги будут ограничено шататься)
#2. С помощью скелета, костей и polygon2d с текстуркой части тела преобразить персонажа.
#3. При прыжке, установить для leg такую angular_velocity или определ. impulce, чтобы нога сделала вращение, а дальше lerp вернуло к нужному углу.

"""if round(current_degrees*10)/10-0.1 == desangle_foot1_jump: #Если текущий угол скорректировался до desangle_foot1_jump,
			$Foot1.mode = RigidBody2D.MODE_CHARACTER # то закрепляем ноги от вращения по оси
			$RigidBody2D.mode = RigidBody2D.MODE_CHARACTER
		else:
			$Foot1.mode = RigidBody2D.MODE_RIGID
			$RigidBody2D.mode = RigidBody2D.MODE_RIGID"""

