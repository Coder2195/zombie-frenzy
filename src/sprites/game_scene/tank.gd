class_name Tank extends Vehicle

func _physics_process(delta):
  super._physics_process(delta);
  var player = get_tree().get_root().get_node("GameScene/Player") as Player;
  var rideable = $Interact.overlaps_body(player) && player.vehicle == null && durability > 0;

  $InteractMenu.visible = rideable;
  if (rideable):
    $InteractMenu.rotation = - rotation;
    $InteractMenu.global_position = self.global_position + Vector2(0, 50) - $InteractMenu.size / 2;
    

  if passenger == null:
    if Input.is_action_just_pressed("use") && rideable:
      ride(get_tree().get_root().get_node("GameScene/Player"))
    else:
      return ;


func _process(delta):
  if passenger == null:
    return ;
  $Turret.global_rotation = get_global_mouse_position().direction_to(global_position).angle() + deg_to_rad(180);
