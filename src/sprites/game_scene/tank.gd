class_name Tank extends Vehicle

func _physics_process(delta):
  super._physics_process(delta);


  if passenger == null:
    if Input.is_action_just_pressed("use"):
      ride(get_tree().get_root().get_node("GameScene/Player"))
    else:
      return ;


func _process(delta):
  if passenger == null:
    return ;
  $Turret.global_rotation = get_global_mouse_position().direction_to(global_position).angle() + deg_to_rad(180);
