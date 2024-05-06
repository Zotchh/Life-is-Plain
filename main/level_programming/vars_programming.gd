extends Node

var res_root: String = "res://assets/sprites/key_icons/"

# Instructions for Programming minigame
var i_header = Instruction.new("Header", "H", "minigame_h", res_root + "key_h.tres")
var i_name = Instruction.new("Name", "N", "minigame_n", res_root + "key_n.tres")
var i_constructor = Instruction.new("Constructor", "C", "minigame_c", res_root + "key_c.tres")
var i_attribute = Instruction.new("Attribute", "A", "minigame_a", res_root + "key_a.tres")
var i_method = Instruction.new("Method", "M", "minigame_m", res_root + "key_m.tres")
var i_getter = Instruction.new("Getter", "G", "minigame_g", res_root + "key_g.tres")
var i_setter = Instruction.new("Setter", "S", "minigame_s", res_root + "key_s.tres")
var i_body = Instruction.new("Body", "B", "minigame_b", res_root + "key_b.tres")
var i_return = Instruction.new("Return", "R", "minigame_r", res_root + "key_r.tres")
var i_parameter = Instruction.new("Parameter", "P", "minigame_p", res_root + "key_p.tres")
var i_loop = Instruction.new("Loop", "L", "minigame_l", res_root + "key_l.tres")
var i_layout = Instruction.new("Layout", "L", "minigame_l", res_root + "key_l.tres")
var i_content = Instruction.new("Content", "C", "minigame_c", res_root + "key_c.tres")
var i_footer = Instruction.new("Footer", "F", "minigame_f", res_root + "key_f.tres")
var i_link = Instruction.new("Link", "K", "minigame_k", res_root + "key_k.tres")
var i_web_image = Instruction.new("Web Image", "W", "minigame_w", res_root + "key_w.tres")
var i_menu = Instruction.new("Menu", "M", "minigame_m", res_root + "key_m.tres")
var i_social = Instruction.new("Social Widget", "S", "minigame_s", res_root + "key_s.tres")
var i_hostname = Instruction.new("Hostname", "H", "minigame_h", res_root + "key_h.tres")
var i_port = Instruction.new("Port", "P", "minigame_p", res_root + "key_p.tres")
var i_connection = Instruction.new("Connection", "C", "minigame_c", res_root + "key_c.tres")
var i_receive = Instruction.new("Receive", "R", "minigame_r", res_root + "key_r.tres")
var i_send = Instruction.new("Send", "S", "minigame_s", res_root + "key_s.tres")

# Sequences for Programming minigame
var s_class = Sequence.new(
	"class",
	[i_header, i_name, i_constructor],
	[i_attribute, i_method],
	[i_getter, i_setter],
	[i_header, i_name, i_attribute, i_constructor, i_method, i_getter, i_setter]
)
var s_function = Sequence.new(
	"function",
	[i_header, i_name, i_body, i_return],
	[i_parameter],
	[i_loop],
	[i_header, i_name, i_parameter, i_body, i_loop, i_return]
)
var s_server = Sequence.new(
	"server script",
	[i_hostname, i_port],
	[i_connection],
	[i_receive],
	[i_hostname, i_port, i_connection, i_receive]
)
var s_client = Sequence.new(
	"client script",
	[i_hostname, i_port],
	[i_connection],
	[i_send],
	[i_hostname, i_port, i_connection, i_send]
)
var s_website = Sequence.new(
	"website",
	[i_header, i_layout, i_content, i_footer],
	[i_link, i_web_image, i_menu],
	[i_social],
	[i_header, i_layout, i_menu, i_content, i_web_image, i_social, i_footer]
)

# Global array for public access
var sequences: Array = [
	s_class,
	s_function,
	s_website,
	s_server,
	s_client
]
