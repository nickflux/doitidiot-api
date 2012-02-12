(function() {
  var Todo;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  jQuery(function() {
    if ($('#new_todo').length) new Todo();
    $.retrieveJSON("/todos.json", function(todos) {
      return $(todos).each(function(i, todo) {
        return $('#todos').append('<li id="todo_' + todo._id + '">' + Mustache.to_html($('#todo_template').html(), todo) + '</li>');
      });
    });
    $("#todos").sortable({
      axis: 'y',
      handle: '.handle',
      update: function() {
        return $.post($(this).data('sort-url'), $(this).sortable('serialize'));
      }
    });
    return $("#todos").disableSelection();
  });

  Todo = (function() {

    function Todo() {
      this.create = __bind(this.create, this);
      this.show = __bind(this.show, this);      $('#new_todo input[type=submit]').click(this.create);
      $('.edit_todo').click(this.edit);
      $('.destroy_todo').click(this.destroy);
      $('.complete_todo').click(this.complete);
      $('#todos').on("click", '.update_todo', this.update);
    }

    Todo.prototype.show = function(todo) {
      $('#new_todo input[type=text]').val("");
      return $('#todos').append('<li id="todo_' + todo._id + '">' + Mustache.to_html($('#todo_template').html(), todo) + '</li>');
    };

    Todo.prototype.create = function() {
      var create_todo_url;
      create_todo_url = $('#new_todo input[type=submit]').data('url');
      $.ajax({
        type: 'POST',
        url: create_todo_url,
        data: $("#new_todo").serialize(),
        dataType: 'json',
        success: this.show
      });
      return false;
    };

    Todo.prototype.edit = function() {
      var edit_todo_url, list_item;
      edit_todo_url = $(this).data('url');
      list_item = $(this).parent();
      return $.ajax({
        type: 'GET',
        url: edit_todo_url,
        dataType: 'json',
        success: function(todo) {
          return $(list_item).html(Mustache.to_html($('#edit_todo_template').html(), todo));
        }
      });
    };

    Todo.prototype.update = function() {
      var list_item, update_todo_url, what_to_do_value;
      update_todo_url = $(this).data('url');
      what_to_do_value = $(this).parent().find('input').val();
      list_item = $(this).parent();
      return $.ajax({
        type: 'PUT',
        url: update_todo_url,
        data: {
          todo: {
            what_to_do: what_to_do_value
          }
        },
        dataType: 'json',
        success: function() {
          return $.getJSON(update_todo_url, function(todo) {
            return $(list_item).html(Mustache.to_html($('#todo_template').html(), todo));
          });
        }
      });
    };

    Todo.prototype.destroy = function() {
      var destroy_todo_url, list_item;
      destroy_todo_url = $(this).data('url');
      list_item = $(this).parent();
      return $.ajax({
        type: 'DELETE',
        url: destroy_todo_url,
        dataType: 'json',
        success: function() {
          return $(list_item).remove();
        }
      });
    };

    Todo.prototype.complete = function() {
      var list_item, update_todo_url;
      update_todo_url = $(this).data('url');
      list_item = $(this).parent();
      return $.ajax({
        type: 'PUT',
        url: update_todo_url,
        data: {
          todo: {
            complete: true
          }
        },
        dataType: 'json',
        success: function() {
          return $(list_item).remove();
        }
      });
    };

    return Todo;

  })();
}).call(this);