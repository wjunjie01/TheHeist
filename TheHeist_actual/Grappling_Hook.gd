class_name GrapplingHook_Class
extends Node2D

signal S_On_Hook_Reached

@export var m_SnapToObject : Node2D

@onready var m_LinkNode : Sprite2D = $Link
@onready var m_HookNode : Sprite2D = $Hook

@export var m_HookSpeed : float = 1200.0
@export var m_HookReachedOffset : float = 10

var m_TargetPos : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	m_TargetPos = m_HookNode.global_position
	Deactivate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Dont do anything if not visible in tree
	if !is_visible_in_tree():
		return
	
	UpdateHook(delta)
	UpdateLink()

func UpdateHook(delta : float):
	#Move hook only if its not there yet
	var diffVec : Vector2 = m_TargetPos - m_HookNode.global_position
	var diffLength : float = diffVec.length()
	
	if diffLength >= m_HookReachedOffset:
		var direction : Vector2 = (diffVec).normalized()
		m_HookNode.global_position += direction * m_HookSpeed * delta
		
		if (m_TargetPos - m_HookNode.global_position).length() <= m_HookReachedOffset:
			S_On_Hook_Reached.emit()
	
	pass

func UpdateLink():
	#Snap link to player
	if m_SnapToObject:
		m_LinkNode.global_position = m_SnapToObject.global_position
	
	#Get height of link
	var diffVec : Vector2 = m_HookNode.global_position - m_LinkNode.global_position
	m_LinkNode.region_rect.size.y = (diffVec).length()
	m_LinkNode.offset.y = -m_LinkNode.region_rect.size.y/2
	
	#Get rotation of link
	var rotationDegree : float = diffVec.normalized().angle() #Radian
	rotationDegree = rad_to_deg(rotationDegree) #Convert to degree
	
	m_LinkNode.rotation_degrees = rotationDegree + 90

func Activate(target : Vector2):
	#Snap all to player
	if m_SnapToObject:
		m_HookNode.global_position = m_SnapToObject.global_position
		m_LinkNode.global_position = m_SnapToObject.global_position
	else:
		m_HookNode.position = Vector2.ZERO
		m_LinkNode.position = Vector2.ZERO
	
	#Set target pos and set length of link to 0
	m_TargetPos = target
	m_LinkNode.region_rect.size.y = 0
	m_LinkNode.offset.y = 0
	
	#Rotation of hook
	var direction = (m_TargetPos - m_HookNode.global_position).normalized()
	m_HookNode.rotation = direction.angle() + 90
	
	visible = true

func Deactivate():
	visible = false
