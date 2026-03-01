class_name Crate extends StaticBody2D;

static var scene: PackedScene = preload("res://sprites/game_scene/crate.tscn");

func create() -> Crate:
  var this = scene.instantiate() as Crate;
  return this;

func _physics_process(delta: float) -> void:
  var player = get_node("/root/GameScene/Player") as Player;
  if player == null:
    $Interact.visible = false;
    return ;
  $Interact.visible = $InteractArea.overlaps_body(player);
  if $InteractArea.overlaps_body(player) && Input.is_action_just_pressed("use"):
    var item = Player.ItemData.new(GameConstants.items[randi() % GameConstants.items.size()], randi_range(1, 3));
    player.give(item);
    queue_free();
