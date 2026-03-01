class_name Player extends RigidBody2D;

const SPEED = 1500.0;
const TURN_SPEED = 7.5;

var health = 100.0;
var stamina = 100.0;
var last_run = Time.get_ticks_msec()

var vehicle: Vehicle = null;

func _physics_process(delta):
  freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC;
  var target_rotation = get_global_mouse_position().direction_to(global_position).angle() + deg_to_rad(180);
  
  self.global_rotation = target_rotation;

  
  if vehicle == null:
    var vertical = Input.get_axis("up", "down");
    var sideways = Input.get_axis("left", "right");
    var sprint = Input.get_action_strength("sprint") * 0.5 + 1.0;

    var current_time = Time.get_ticks_msec();

    if sprint > 1.0:
      last_run = current_time;

    
    if stamina > 0 && sprint > 1.0:
      stamina -= delta * 10;
    elif sprint == 1.0:
      stamina += delta * 4 * (atan((current_time - last_run) * 0.001 - 6) + PI / 2);
      

    if stamina > 100:
      stamina = 100;
    
    if stamina <= 0:
      sprint = 1.0;
      stamina = 0;

    (get_node("/root/GameScene/GUI") as GUI).set_stamina(stamina);
    
    apply_central_force(Vector2(sideways, vertical).normalized() * SPEED * sprint - linear_velocity * 10);

    if Input.is_action_just_pressed("fire"):
      var bullet = Bullet.create(self , Vector2(17, 9));
      get_parent().add_child(bullet);
      $Pistol.play();
  
  if health <= 0:
    get_tree().change_scene_to_file("res://scenes/death_screen.tscn");
    return ;
  
 
func damage(dmg: float):
  health -= dmg;
  (get_node("/root/GameScene/GUI") as GUI).set_health(health);
  $Hurt.play();
