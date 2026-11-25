# Release Notes — flux_mentions

## Public release – 25 Nov 2026
- First public release on GitHub. The whole plugin is now licensed under the GNU GPL v2.

## [7.0.0 / 6.0.0] — 2026-11-03

### Compatibility
- Released as 7.0.0 for Redmine 7.x (Rails 8.1, Ruby 3.2–4.0) on `release/7.0.0` and as 6.0.0 for Redmine 6.x (Rails 7.2, Ruby 3.1–3.4) on `release/6.0.0`, from the same code. Version 5.0.0, with the same features, is published for Redmine 5.x on the `release/5.0.0` branch.
- Version numbers now follow the Redmine major version they're built for.

### Performance
- Issue and wiki forms load the mentionable user list in a single query instead of one query per user.
- Mention notifications on issues, journals and wiki pages load only the mentioned users instead of every project member.

### Bug Fixes
- `parse_redmine_links` override now wraps the core method instead of replacing it, so `#issue`, `r123`, wiki and other Redmine link syntax renders again (including for other plugins that chain onto the same method).
- The plugin's autocomplete no longer attaches on page load and blocks core Redmine's `#` (issue) and `[[` (wiki page) autocomplete. With the default `@` symbol, core Redmine's own user autocomplete is used.

---

## [6.0.0] — 2026-03-26

### Features
- Initial plugin release: @mention autocomplete in issue comments, descriptions and wiki pages; email notification on mention with issue context and a direct link; configurable mention symbol (default: `@`)
