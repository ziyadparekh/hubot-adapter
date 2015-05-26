Robot   = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
EnterMessage = require('hubot').EnterMessage
User = require('hubot').User

WebSocket = require('ws');


class LCB extends Adapter

  constructor: (@robot) ->
    super @robot
    @robot.logger.info "Constructor"


  send: (envelope, strings...) ->
    @robot.logger.info "Send"
    for str in strings
      @socket.send "#{str}"

  reply: (envelope, strings...) ->
    for str in strings
      @socket.send "#{str}"

  run: ->
    @socket = new WebSocket 'ws://localhost:8080/ws/5563b70a3c5d631c51000001?token=555e92a93c5d6387f9000004_eab77e273ee30e2d4f61b08c44ed657974f1fab5f75afd1865659fd739919ae9'
    @socket.on 'open', =>
      console.log 'connected'
      @emit 'connected'

    @socket.on 'message', (data, flags) =>
      user = new User 1001, name: 'Sample User'
      message = new TextMessage user, data, 'MSG-001'
      @receive message

    @robot.logger.info "Run"

exports.use = (robot) ->
  new LCB robot