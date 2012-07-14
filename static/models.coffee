$ ->
  class window.tt.Client extends Backbone.Model
    idAttribute: "_id"
    defaults: ->
      name: "Joe Random Client"
    parse: (data) =>
      data[@idAttribute] = data[@idAttribute].$oid # ugly mongodb hack
      data

  class window.tt.ClientCollection extends Backbone.Collection
    model: window.tt.Client
    url: '/clients'
    initialize: () =>
      @bind "add", (client) ->
        console.log client

  class window.tt.Project extends Backbone.Model
    idAttribute: "_id"
    validate: (attrs) ->
      if attrs.client is null
        return "Client cannot be null"
    defaults: ->
      name: "A Project"
      client: null
    parse: (data) =>
      data[@idAttribute] = data[@idAttribute].$oid
      data

  class window.tt.ProjectCollection extends Backbone.Collection
    model: window.tt.Project
    url: '/projects'
    initialize: () =>
      @bind "add", (project) ->
        console.log project
