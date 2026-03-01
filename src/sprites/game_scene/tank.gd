class_name Tank extends Vehicle

var last_shot = Time.get_ticks_msec()


func _physics_process(delta):
  super._physics_process(delta);
  var player = get_tree().get_root().get_node("GameScene/Player") as Player;
  var rideable = $Interact.overlaps_body(player) && player.vehicle == null && durability > 0;

  $InteractMenu.visible = rideable;
  if (rideable):
    $InteractMenu.rotation = - rotation;
    $InteractMenu.global_position = self.global_position + Vector2(0, 50) - $InteractMenu.size / 2;

  if Input.is_action_pressed("fire") && last_shot + 100 < Time.get_ticks_msec() && passenger != null:
    var bullet = Bullet.create($Turret, Vector2(0, 30), 20);
    bullet.creator = self ;
    bullet.global_position = $Turret.global_position + Vector2(60, 0).rotated($Turret.global_rotation);
    bullet.global_rotation = $Turret.global_rotation;
    get_tree().get_root().get_node("GameScene/").add_child(bullet);
    last_shot = Time.get_ticks_msec();
    $MachineGun.play();
  
  if last_shot + 200 < Time.get_ticks_msec():
    $MachineGun.stop();
    
    
  if passenger == null:
    if Input.is_action_just_pressed("use") && rideable:
      ride(get_tree().get_root().get_node("GameScene/Player"))
    else:
      return ;

func _process(delta):
  if passenger == null:
    return ;
  $Turret.global_rotation = get_global_mouse_position().direction_to(global_position).angle() + deg_to_rad(180);
