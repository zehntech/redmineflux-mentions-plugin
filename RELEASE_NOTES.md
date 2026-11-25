# Release Notes — flux_mentions

## Public release – 25 Nov 2026
- First public release on GitHub. The whole plugin is now licensed under the GNU GPL v2.

## [5.0.0] — 2026-11-03

### Compatibility
- Release for Redmine 5.x (Rails 6.1, Ruby 2.7–3.2). Versions 7.0.0 and 6.0.0, with the same features, are published for Redmine 7.x on `master` and the `release/7.0.0` branch, and for Redmine 6.x on the `release/6.0.0` branch.
- Version numbers now follow the Redmine major version they're built for.

### Upgrade notes
- If you run plugin 6.0.0 (which covered Redmine 4.x–6.x) on Redmine 5.x, replace it with 5.0.0 from this branch and restart Redmine. The plugin has no database migrations.

### Features
- @mention autocomplete in issue comments, descriptions and wiki pages; email notification on mention with issue context and a direct link; configurable mention symbol (default: `@`)

### Performance
- Issue and wiki forms load the mentionable user list in a single query instead of one query per user.
- Mention notifications on issues, journals and wiki pages load only the mentioned users instead of every project member.

### Bug Fixes
- `parse_redmine_links` override now wraps the core method instead of replacing it, so `#issue`, `r123`, wiki and other Redmine link syntax renders again (including for other plugins that chain onto the same method).
- The plugin's autocomplete no longer attaches on page load and blocks core Redmine's `#` (issue) and `[[` (wiki page) autocomplete. With the default `@` symbol, core Redmine's own user autocomplete is used.

