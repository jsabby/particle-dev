SettingsHelper = null
MenuManager = null
StatusView = null
LoginView = null
CoresView = null
RenameCoreView = null

module.exports =
  statusView: null
  loginView: null
  coresView: null
  renameCoreView: null

  activate: (state) ->
    # Require modules on activation
    StatusView ?= require './views/status-bar-view'
    SettingsHelper ?= require './utils/settings-helper'
    MenuManager ?= require './utils/menu-manager'

    # Initialize views
    @statusView = new StatusView()

    # Hooking up commands
    atom.workspaceView.command 'spark-ide:login', => @login()
    atom.workspaceView.command 'spark-ide:logout', => @logout()
    atom.workspaceView.command 'spark-ide:select-core', => @selectCore()
    atom.workspaceView.command 'spark-ide:rename-core', => @renameCore()

    atom.workspaceView.command 'spark-ide:update-menu', => MenuManager.update()

    MenuManager.update()

  deactivate: ->
    @statusView?.destroy()

  serialize: ->

  login: ->
    LoginView ?= require './views/login-view'
    @loginView ?= new LoginView()
    # You may ask why this isn't in LoginView? This way, we don't need to
    # require/initialize login view until it's needed.
    atom.workspaceView.command 'spark-ide:cancel-login', => @loginView.cancelCommand()
    @loginView.show()

  logout: ->
    if !SettingsHelper.isLoggedIn()
      return

    LoginView ?= require './views/login-view'
    @loginView ?= new LoginView()

    @loginView.logout()

  selectCore: ->
    CoresView ?= require './views/select-core-view'
    @coresView ?= new CoresView()

    if !SettingsHelper.isLoggedIn()
      return

    @coresView.show()

  renameCore: ->
    RenameCoreView ?= require './views/rename-core-view'

    if !SettingsHelper.isLoggedIn()
      return

    if !SettingsHelper.hasCurrentCore()
      return

    @renameCoreView = new RenameCoreView(SettingsHelper.get 'current_core_name')
    @renameCoreView.attach()
