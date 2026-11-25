require File.expand_path('../../test_helper', __FILE__)

# rmn-001 — with the core view override removed, Administration > Plugins
# still renders and lists this plugin with its configure link.
class Rmn001AdminPluginsPageTest < Redmine::ControllerTest
  tests AdminController
  fixtures :projects, :users, :email_addresses, :roles

  def setup
    @request.session[:user_id] = 1 # admin
  end

  test 'Administration > Plugins lists the Mentions plugin' do
    get :plugins
    assert_response :success
    assert_select 'tr#plugin-flux_mentions td.name span.name', text: 'Redmineflux Mentions plugin'
    assert_select 'tr#plugin-flux_mentions td.version', text: Redmine::Plugin.find(:flux_mentions).version
  end

  test 'Administration > Plugins shows the configure link for the Mentions plugin' do
    get :plugins
    assert_response :success
    assert_select 'tr#plugin-flux_mentions td.configure a[href=?]', '/settings/plugin/flux_mentions'
  end
end
