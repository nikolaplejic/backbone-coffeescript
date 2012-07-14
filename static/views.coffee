$ ->
  window.tt.isClientSelected = () ->
    if $("#client option:selected").val() is "" or $("#client option:selected").val() is "new"
      return false
    return true

  window.tt.isProjectSelected = () ->
    if $("#project option:selected").val() is "" or $("#project option:selected").val() is "new"
      return false
    return true

  window.tt.hasTask = () ->
    if $("#task").val().length == 0
      return false
    return true

  class window.tt.TimeTracker extends Backbone.View
    el: $("#app-container")

    initialize: () ->
      @tasks = new window.tt.TaskCollection null, { view: @ }
      tasks_jqxhr = @tasks.fetch()
      $.when(tasks_jqxhr).done () =>
        @render()

      $("#time span").html(0)
      $("#toggle-time").data("status", "stopped")
      
    handleTimeToggle: (e) =>
      e.preventDefault()

      if !window.tt.isClientSelected() or !window.tt.isProjectSelected() or !window.tt.hasTask()
        alert "Please select a project and/or a client and/or enter a task"
        return false

      if $("#toggle-time").data("status") is "stopped"
        $("#toggle-time").data("status", "started")
        $("#toggle-time").html("Stop")
        # start the clock
        window.tt.timeintv = setInterval () ->
          time = parseInt $("#time span").html()
          $("#time span").html(++time)
        , 1000
      else
        clearInterval window.tt.timeintv

        $("#toggle-time").data("status", "stopped")
        $("#toggle-time").html("Start")
        time = parseInt $("#time span").html()

        task_model =
          name: $("#task").val()
          time_spent: time
          project: $("#project option:selected").val()

        @tasks.create(task_model, {
          at: 0,
          wait: true,
          success: () =>
            $("#time span").html(0)
            $("#task").val("")
            @render()
        })
      @

    render: () =>
      $("#task-list").empty()

      task_template = _.template $("#task-list-entry-template").html()
      @tasks.each (t) =>
        $("#task-list").append task_template({ id: t.id, project: "foo", time_spent: t.get('time_spent'), task: t.get('name') })
      @

    events:
      "click #toggle-time": "handleTimeToggle"

  class window.tt.ClientList extends Backbone.View
    el: $("#client")

    initialize: () =>
      @clients = new window.tt.ClientCollection null, { view: @ }
      clients_jqxhr = @clients.fetch()
      $.when(clients_jqxhr).done () =>
        @render()

    handleChange: () =>
      if $("option:selected", @el).val() is "new"
        client = prompt "Name of client?"

        if client != null
          client_model = name: client
          @clients.create(client_model, { at: 1, wait: true, success: () => @render() })
      else if $("option:selected", @el).val() is ""
        console.log "bar"
      else
        console.log "foo"
      @

    render: () =>
      $(@el).empty()
      $(@el).append $("<option>").val("").html("")

      client_template = _.template $("#client-template").html()
      @clients.each (c) =>
        $(@el).append client_template({ id: c.id, name: c.get('name') })

      $(@el).append $("<option>").val("new").html("add...")

    events:
      "change": "handleChange"

  class window.tt.ProjectList extends Backbone.View
    el: $("#project")

    initialize: () =>
      @projects = new window.tt.ProjectCollection null, { view: @ }
      projects_jqxhr = @projects.fetch()
      $.when(projects_jqxhr).done () =>
        @render()

    handleChange: (e) =>
      if $("option:selected", @el).val() is "new"
        if !window.tt.isClientSelected()
          alert "Please select a client"
          return false

        project = prompt "Name of project?"

        if project != null
          project_model =
            name: project
            client: $("#client option:selected").val()
          @projects.create(project_model, { at: 1, wait: true, success: () => @render() })
          @render()
      else if $("option:selected", @el).val() is ""
        console.log "bar"
      else
        console.log "foo"
      @

    render: () =>
      $(@el).empty()
      $(@el).append $("<option>").val("").html("")

      project_template = _.template $("#project-template").html()
      @projects.each (c) =>
        $(@el).append project_template({ id: c.id, name: c.get('name') })

      $(@el).append $("<option>").val("new").html("add...")

    events:
      "change": "handleChange"
