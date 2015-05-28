Robot   = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
EnterMessage = require('hubot').EnterMessage
User = require('hubot').User

WebSocket = require('ws');

CHATBOT_ID = process.env.CHATBOT_ID || "555f47ce09dce15f73000001";

class OCB extends Adapter

  constructor: (@robot) ->
    super @robot
    @robot.logger.info "Constructor"


  send: (envelope, strings...) ->
    @robot.logger.info "Send"
    for str in strings
      @socket.send JSON.stringify
        groupId: envelope.room,
        content: str

  reply: (envelope, strings...) ->
    @robot.logger.info "Reply"
    for str in strings
      @socket.send JSON.stringify
        groupId: envelope.room,
        content: str

  process: (data) ->
    try
      data = JSON.parse data
    catch e
      console.log e
      return
    user = new User data.sender, name: data.sender, room: data.group
    message = new TextMessage user, data.content
    return message

  run: ->
    @socket = new WebSocket 'ws://localhost:8080/ws/chatbot/' + CHATBOT_ID
    @socket.on 'open', =>
      console.log 'connected'
      @emit 'connected'

    @socket.on 'close,' =>
      # add code to retry connect
      console.log 'disconnected'

    @socket.on 'message', (data, flags) =>
      message = @process data
      @receive message

    @robot.logger.info "Run"

exports.use = (robot) ->
  new OCB robot
