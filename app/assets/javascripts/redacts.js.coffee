jQuery ->
  new Redact()
    
class Redact
  constructor: ->
    @getRedacts()
    $(document).on("ready", @applyRedacts)
    $('#todos').bind("todos_loaded", @applyBlacklists)
    
  getRedacts: =>
    if !localStorage["redacts"]
      localStorage["redacts"] = JSON.stringify([]);
    # get redacts from online
    if (window.navigator.onLine)
      all_redacts = []
      $.getJSON '/redacts.json', (data) ->
        $(data).each (i, redact_object) ->
          redact  =
            code_name: redact_object.code_name,
            redact_array: redact_object.redact_array.slice(1, 20)
          all_redacts[i] = redact
        localStorage["redacts"] = JSON.stringify(all_redacts)
    @redacts            = $.parseJSON localStorage["redacts"]
    @redact_code_names  = $.map @redacts, (redact, i) ->
      redact.code_name
    
  applyRedacts: =>
    self  = this
    $(@redact_code_names).each (index, redact_code_name) ->
      redact_array  = $.grep(self.redacts, (redact, i) -> 
        redact.code_name == redact_code_name)[0].redact_array
      $('.'+redact_code_name).each (i, elm) ->
        $(elm).html self.getRandomRedactItem(redact_array)
        
  applyBlacklists: =>
    blacklist_array  = $.grep(@redacts, (redact, i) -> 
      redact.code_name == 'blacklist')[0].redact_array
    emoticons_array  = $.grep(@redacts, (redact, i) -> 
      redact.code_name == 'emoticons')[0].redact_array
    $('#todos li').each (j, elm) ->
      content = $(elm).html()
      $(blacklist_array).each (k, blacklist_item) ->
        content = content.replace(blacklist_item, '[REDACTED]')
      $(emoticons_array).each (k, emoticon_item) ->
        content = content.replace(emoticon_item, ':(')
      $(elm).html content
            
          
  getRandomRedactItem: (redact_array) =>
    redact_array[Math.floor(Math.random()*redact_array.length)];