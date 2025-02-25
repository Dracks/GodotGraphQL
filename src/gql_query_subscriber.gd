extends Node

class_name GQLQuerySubscriber

signal new_data
signal closed

var _client := WebSocketClient.new()
var endpoint: String
var query: String

var subscription_completed:=false

func _init(_endpoint: String, _query: GQLQuery):
	endpoint = _endpoint
	query = _query.serialize()

func _ready():
	_client.connection_closed.connect(_closed)
	_client.connected_to_server.connect(_connected)
	_client.message_received.connect(_on_data)
	_client.supported_protocols = PackedStringArray(["graphql-ws"])
	add_child(_client)

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(endpoint)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.send("{\"type\": \"connection_init\",\"payload\": {}}")

func _on_data(data):
	var json := JSON.new()
	json.parse(data)
	if json.data.type == "data":
		new_data.emit(json.data.payload.data)
	elif json.data.type =="connection_ack":
		var to_complete_subscription = JSON.stringify({
			"type": "start",
			"id": "1",
			"payload": {
				"query": query
			}
		})
		_client.send(to_complete_subscription)
		subscription_completed = true

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
