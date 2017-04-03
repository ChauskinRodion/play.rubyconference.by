$ ->

  $.ui.autocomplete.prototype._renderMenu = (ul, items)->
    self = this
    ul.append("<table class='table'><thead><tr><th>Status</th><th>Title</th><th>User</th><th>Logo</th></tr></thead><tbody></tbody></table>")
    $.each( items, (index, item)->
      self._renderItemData(ul, ul.find("table tbody"), item )
    )

  $.ui.autocomplete.prototype._renderItemData = (ul,table, item)->
    this._renderItem(table, item)

  $.ui.autocomplete.prototype._renderItem = (table, item)->
    # $( "<tr class='ui-menu-item' role='presentation'></tr>" )
    #   .data( "item.autocomplete", item )
    $( "<tr></tr>" )
      .append( "<td><img width=\"80\" src=\"images/" + (if item.merged then 'merged.png' else 'closed.png') + "\"></td>" +
               "<td>#{item.title}</td>" +
               "<td>#{item.author}</td>" +
               "<td><img src=\"#{item.authorLogo}\" width=\"30\"></td>" )
      .appendTo( table )

  $('.autocomplete').autocomplete({
      source: '/index.json'
      delay: 0
      minLength: 3
  })
