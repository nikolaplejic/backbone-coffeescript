$ ->
  class ttRouter extends Backbone.Router
    routes:
      "*action": "defaultRoute"

    defaultRoute: (actions) ->
      window.tt.tt = new window.tt.TimeTracker
      window.tt.cl = new window.tt.ClientList
      window.tt.pl = new window.tt.ProjectList

  window.tt.router = new ttRouter()
  Backbone.history.start()
