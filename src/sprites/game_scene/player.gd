class_name Player extends RigidBody2D;

const SPEED = 1500.0;
const TURN_SPEED = 7.5;

var health = 100.0;
var stamina = 100.0;
var last_run = Time.get_ticks_msec()

var vehicle: Vehicle = null;

class ItemData:
  func _init(_name: String, _count: int):
    name = _name;
    count = _count;
  var name: String;
  var count: int;

var inventory: Array[ItemData] = [ItemData.new("gun", 1), null, null, null, null, null, null, null];
var selected_item = 0;

func set_selected_item(index: int):
  selected_item = index;
  (get_node("/root/GameScene/GUI") as GUI).set_selected(index);
  if index == 0:
    $Sprite.visible = true;
    $SpriteItem.visible = false;
    $Item.visible = false;
  else:
    $Sprite.visible = false;
    $SpriteItem.visible = true;
    if inventory[index] == null:
      $Item.visible = false;
    else:
      $Item.animation = inventory[index].name;
      $Item.visible = true;


func _physics_process(delta):
  var target_rotation = get_global_mouse_position().direction_to(global_position).angle() + deg_to_rad(180);
  
  self.global_rotation = target_rotation;

  var current_time = Time.get_ticks_msec();

  var sprint = 1.0;

  var vertical = Input.get_axis("up", "down");
  var sideways = Input.get_axis("left", "right");

  if Input.is_action_just_pressed("1"):
    set_selected_item(0);
  elif Input.is_action_just_pressed("2"):
    set_selected_item(1);
  elif Input.is_action_just_pressed("3"):
    set_selected_item(2);
  elif Input.is_action_just_pressed("4"):
    set_selected_item(3);
  elif Input.is_action_just_pressed("5"):
    set_selected_item(4);
  elif Input.is_action_just_pressed("6"):
    set_selected_item(5);
  elif Input.is_action_just_pressed("7"):
    set_selected_item(6);
  elif Input.is_action_just_pressed("8"):
    set_selected_item(7);

  if selected_item > 0 && Input.is_action_just_pressed("inventory_use") && vehicle == null:
    use_item();
 
  
  if vehicle == null:
    sprint = Input.get_action_strength("sprint") * 0.5 + 1.0;

    
  if sprint > 1.0:
    last_run = current_time;

  if stamina > 0 && sprint > 1.0 && (vertical != 0 || sideways != 0):
    # only move when sprint, and moving in some direction
    stamina -= delta * 10;
  else:
    stamina += delta * 4 * (atan((current_time - last_run) * 0.001 - 6) + PI / 2);
    

  if stamina > 100:
    stamina = 100;
  
  if stamina <= 1 && sprint > 1.0:
    sprint = 1.0;
    stamina = 0;

  
  if vehicle == null:
    apply_central_force(Vector2(sideways, vertical).normalized() * SPEED * sprint - linear_velocity * 10);

    if Input.is_action_just_pressed("fire") && selected_item == 0:
      var bullet = Bullet.create(self , Vector2(17, 9));
      get_parent().add_child(bullet);
      $Pistol.play();

  (get_node("/root/GameScene/GUI") as GUI).set_stamina(stamina);
  
  if health <= 0:
    get_tree().change_scene_to_file("res://scenes/death_screen.tscn");
    return ;
  
 
func damage(dmg: float):
  health -= dmg;
  var gui = get_node("/root/GameScene/GUI") as GUI;
  gui.set_health(health);
  gui.take_damage();

  $Hurt.play();


func _ready():
  set_selected_item(0);


func give(item: ItemData) -> bool:
  var success = false;
  for i in range(0, inventory.size()):
    if inventory[i] == null:
      continue ;
    if inventory[i].name == item.name:
      inventory[i].count += item.count;
      success = true;
      break ;
  if (!success):
    for i in range(0, inventory.size()):
      if inventory[i] == null:
        inventory[i] = item;
        success = true;
        break ;
  var gui = get_node("/root/GameScene/GUI") as GUI;
  gui.set_inventory(inventory);
  return success;

func use_item():
  var gui = get_node("/root/GameScene/GUI") as GUI;
  var selected = inventory[selected_item];
  if selected == null: return ;

  if selected.name == "medkit":
    if health >= 100:
      return ;
    health += 40;
    if health > 100:
      health = 100;
    if (gui != null):
      gui.set_health(health);
  
  elif selected.name == "landmine":
    print("Placing landmine");
    var mine = Landmine.create();
    mine.global_position = global_position + Vector2(50, 0).rotated(rotation);
    get_node("/root/GameScene/").add_child(mine);

  elif selected.name == "forcefield":
    var field = Forcefield.create();
    field.global_position = global_position;
    get_node("/root/GameScene/").add_child(field);

  
  selected.count -= 1;
  if (selected.count <= 0):
    inventory[selected_item] = null;
    set_selected_item(selected_item);

  
  gui.set_inventory(inventory);
