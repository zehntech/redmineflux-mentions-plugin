require File.expand_path('./lib/hook/mention_hooks.rb', __dir__)
require File.expand_path('./lib/patch/issue_controller_patch.rb', __dir__)
require File.expand_path('./lib/patch/wiki_controller_patch.rb', __dir__)
require File.expand_path('./lib/patch/issue_creation_patch.rb', __dir__)
require File.expand_path('./lib/patch/application_helper_patch.rb', __dir__)

Redmine::Plugin.register :flux_mentions do
  name 'Redmineflux Mentions plugin'
  author 'Redmineflux - Powered by Zehntech Technologies Inc'
  description 'Facilitates email notifications for users when mentioned in Notes, Descriptions, and Wiki content.'
  version '6.0.1'
  requires_redmine version_or_higher: '6.0'
  url 'https://www.redmineflux.com/knowledge-base/plugins/mentions-plugin/'
  author_url 'https://www.redmineflux.com'
  settings :default => {'symbol' => '@'}, :partial => 'setting/symbol'
end


