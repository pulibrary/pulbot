POWER_COMMANDS = [
  'hubot-deploy.wcid' # String that matches the listener ID,
  'hubot-deploy.create',
  'hubot-deploy.recent'
]

# These are Slack IDs.
POWER_USERS = [
  'U9QJLS54J', # Trey
  'U9JGCQQQN', # Christina
  'U8C6YATEZ', # James
  'U9UJNLV52', # Eliot
  'U8DJJ8S4S', # Esme
  'U5T4Y86AX', # Nikitas
  'U7YFW7VHA', # Anna
  'U8D46AE1X', # Shaun
  'U78LWHQ21', # Kevin
  '1'
]

module.exports = (robot) ->
  robot.listenerMiddleware (context, next, done) ->
    robot.logger.info context.listener.options
    if context.listener.options.id in POWER_COMMANDS
      if context.response.message.user.id in POWER_USERS
        # User is allowed access to this command
        next()
      else
        # Restricted command, but user isn't in whitelist
        context.response.reply "I'm sorry, @#{context.response.message.user.name}(#{context.response.message.user.id}), but you don't have access to do that."
        done()
    else
      # This is not a restricted command; allow everyone
      next()
