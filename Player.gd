extends KinematicBody2D


var SPEED = 60
var GRAVITY = 10
const JUMP_POWER = -250
const WALL_JUMP = 100
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://Fireball.tscn")
const FIREBALLRED = preload("res://FireballRed.tscn")

var velocity = Vector2()

var on_ground = false

var is_attacking = false

var is_dead = false

var fireball_power = 1

var direction = 1
var is_sliding = false
var dash_duration = 10
var dash_state = false


#Dash = Ui_cancel
#Jump = UI_accept


func _physics_process(delta):
	
	if is_dead == false:
		
		if Input.is_action_pressed("ui_right"): 
			direction = 1
			if is_attacking == false || is_on_floor() == false:
				velocity.x = SPEED
				if is_attacking == false:
					
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
			if is_on_floor() == false && is_on_wall() == true:
				wall_slide()
				if $dash_timer.time_left <= 0:
					SPEED = 60
				
		elif Input.is_action_pressed("ui_left"):
			direction = -1
			if is_attacking == false || is_on_floor() == false:
				if is_attacking == false:
					velocity.x = -SPEED
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
			if is_on_floor() == false && is_on_wall() == true:
				wall_slide()
				if $dash_timer.time_left <= 0:
					SPEED = 60
				
		else:
			velocity.x = 0	
			if is_on_floor() && is_attacking == false:
				$AnimatedSprite.play("idle")
				
				
		#Starting the dash function
		if Input.is_action_just_pressed("ui_cancel") && is_on_floor():
			$dash_timer.start()
		
		#Dash function press hold
		if Input.is_action_pressed("ui_cancel"):
			
			if ($dash_timer.get_time_left() > 0):
				dash()
				
				
		if Input.is_action_just_released("ui_cancel") && is_on_floor():
			$dash_timer.stop()
		
		
		
		#JUMP PRESS	
		if Input.is_action_just_pressed("ui_accept") && is_on_floor(): 
			if is_attacking == false:
				velocity.y = JUMP_POWER
		
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("Attack")
			var fireball = null
			if fireball_power == 1:
				fireball = FIREBALL.instance()
			elif fireball_power == 2:
				fireball = FIREBALLRED.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
			else:
				fireball.set_fireball_direction(-1)
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
		
		
		velocity.y += GRAVITY
		
		#Jump and fall animations
		if is_on_floor():
			if on_ground == false:
					is_attacking = false
			on_ground = true
			
		else:
			if is_attacking == false:
					
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else: 
					$AnimatedSprite.play("fall")
			
		
		#End the dash
		if is_on_floor() == true && $dash_timer.time_left <= 0:
			SPEED = 60
		 
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "enemy" in get_slide_collision(i).collider.name:
					dead()

func wall_slide():
#	if Input.is_action_just_pressed("ui_accept"):
	is_sliding = true
	if Input.is_action_just_pressed("ui_accept") && velocity.y > 0:
		#velocity.x += WALL_JUMP
		if direction == 1:
			velocity.x = -SPEED 
			velocity.y = JUMP_POWER
		if direction == -1:
			velocity.x = SPEED 
			velocity.y = JUMP_POWER
	if velocity.y > 0:
		velocity.y = GRAVITY / 2
	#Wall jump dash
	if Input.is_action_just_pressed("ui_cancel"):
		direction *= -1
		$dash_timer.start()
		
	if Input.is_action_pressed("ui_cancel") && Input.is_action_just_pressed("ui_accept"):
		direction *= -1
		$dash_timer.start()
	
#Dash function	
func dash():
	SPEED  = 180
	if direction == 1:
		velocity.x = SPEED
	elif direction == -1:
		velocity.x = -SPEED
	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Timer.start()
	
func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_Timer_timeout():
	get_tree().change_scene("res://TitleScreen.tscn")


func _on_Tween_tween_completed(object, key):
	pass # Replace with function body.
	
func crown_power_up():
	fireball_power = 2


func _on_dash_timer_timeout():
	if is_on_floor() == true:
		SPEED = 60# Replace with function body.
