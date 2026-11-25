require File.expand_path('../../test_helper', __FILE__)

# rmn-001 — master follows the Redmine 6/7 one-codebase branching standard.
# These checks must pass unchanged on master and on every release branch,
# so they never assert a line-specific version number.
class Rmn001BranchingStandardTest < ActiveSupport::TestCase
  PLUGIN_ROOT = File.expand_path('../..', __dir__)
  COMPAT_FILES = %r{\Alib/flux_mentions/compat(\.rb|/)}

  def plugin_source_files
    files = Dir.glob(File.join(PLUGIN_ROOT, '{app,config,lib}', '**', '*.{rb,erb}'))
    files << File.join(PLUGIN_ROOT, 'init.rb')
    files.map { |path| path.delete_prefix("#{PLUGIN_ROOT}/") }
  end

  def init_rb
    File.read(File.join(PLUGIN_ROOT, 'init.rb'))
  end

  test 'no Redmine version checks outside lib/flux_mentions/compat' do
    offenders = plugin_source_files.reject { |path| path.match?(COMPAT_FILES) }.select do |path|
      File.read(File.join(PLUGIN_ROOT, path)).match?(/Redmine::VERSION/)
    end
    assert_empty offenders, "Move these Redmine version checks into lib/flux_mentions/compat.rb: #{offenders.join(', ')}"
  end

  test 'plugin does not override the core Administration > Plugins view' do
    refute File.exist?(File.join(PLUGIN_ROOT, 'app/views/admin/plugins.html.erb')),
           'app/views/admin/plugins.html.erb shadows the Redmine core view for every plugin'
  end

  test 'plugin version is 0.0.0-dev on master or matches the running Redmine major on a release line' do
    version = Redmine::Plugin.find(:flux_mentions).version
    assert(version == '0.0.0-dev' || version.split('.').first.to_i == Redmine::VERSION::MAJOR,
           "Unexpected plugin version #{version.inspect} on Redmine #{Redmine::VERSION}")
  end

  test 'init.rb declares exactly one requires_redmine line with a Redmine 6 or later floor' do
    lines = init_rb.lines.grep(/^\s*requires_redmine\b/)
    assert_equal 1, lines.size, 'init.rb must declare requires_redmine exactly once'
    floor = lines.first[/['"](\d+)\.\d+/, 1].to_i
    assert_operator floor, :>=, 6, "requires_redmine floor must be 6 or later, got: #{lines.first.strip}"
  end
end
