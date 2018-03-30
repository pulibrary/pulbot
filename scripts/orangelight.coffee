# Description:
#   Search OrangeLight with Pulbot
#
request = require 'request'

CATALOG = "https://catalog.princeton.edu/catalog"
CATALOG_JSON = CATALOG + ".json"
PER_PAGE = 10

formatTitle = (id, title) -> "<#{CATALOG}/#{id}|#{title}>"

listTitles = (body) ->
  "#{i+1}. #{formatTitle(doc.id, doc.title_display)}" for doc, i in body.response.docs

buildResponse= (body, searchURL, searchString) ->
  # helpful: https://api.slack.com/docs/messages/builder
  text = "Search for <#{searchURL}|#{searchString}> returned "
  text = text + "#{body.response.pages.total_count} results:\n"
  text = text + listTitles(body).join('\r\n')

module.exports = (robot) ->
  robot.respond /search (.*)/i, (res) ->
    searchString = res.match[1]
    jsonSearchURL = "#{CATALOG_JSON}?per_page=#{PER_PAGE}&search_field=all_fields&q=#{searchString}"
    htmlSearchURL = "#{CATALOG}?search_field=all_fields&q=#{searchString}"
    request.get {uri: jsonSearchURL, json : true}, (err, r, body) ->
      results = body
      message = buildResponse(results, htmlSearchURL, searchString)

      # BREAKS
      # https://api.slack.com/methods/chat.postMessage
      # robot.adapter.client.web.chat.postMessage(
      #   res.message.room, message, {as_user: true, unfurl_links: false, mrkdwn: true}
      # )

      res.send(message)
