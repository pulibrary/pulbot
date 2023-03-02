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
  'U7YFW7VHA', # Anna
  'U8D46AE1X', # Shaun
  'U78LWHQ21', # Kevin R
  'U69N3MEFL', # Axa
  'UHZUYT0ET', # Carolyn
  'U9S8GSBUJ', # Cliff
  'U8E6TDCP7', # Francis
  'U010TCY02T0', # Kate
  'U01K4C7MA5Q', # Hector
  'U01NWDDAY0K', # Bess
  'U022A15624C', # Bess
  'U023MLQ2W5Q', # Thanya
  'U02ENLGHPJ5', # Alicia
  'U03111RANF6', # Jane
  'U03DR9P0LSJ', # Max
  'U03HWFYA39A', # Taylor
  'U03HU5P1ATD', # Michelle
  'U03JSHSEM5H', # Ryan
  'U03N18A3L0H', # Robert
  'U03N4KUEVCP', # Tyler
  'U046NAFK813', # Chuck
  'UA96YEM5M', #Regine
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
        # Restricted command, but user isn't in allow list
        context.response.reply "I'm sorry, @#{context.response.message.user.name}(#{context.response.message.user.id}), but you don't have access to do that."
        done()
    else
      # This is not a restricted command; allow everyone
      next()
