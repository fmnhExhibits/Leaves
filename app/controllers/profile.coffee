BaseController = require 'zooniverse/controllers/base-controller'
Profile = require 'zooniverse/controllers/profile'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Vue = require 'vue'

$ = window.jQuery

Subject::talkHref = ->
  "http://microplantstalk.zooniverse.org/#/subjects/#{@zooniverse_id}"

class ProfilePage extends BaseController
  className: 'profile page'
  template: require '../views/profile'

  elements:
    '#zooniverse-profile': 'zooniverseProfile'

  constructor: ->
    super

    profileVue = new Vue
      el: @el.get(0)
      data:
        user: {}

    @profile = new Profile
    @zooniverseProfile.append @profile.el

    User.on 'change', (e, user) ->
      # dislike
      if user
        profileVue.$set 'user', $.extend {}, user
      else
        profileVue.$set 'user', false

module.exports = ProfilePage
