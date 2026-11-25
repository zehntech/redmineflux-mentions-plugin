<p align="center">
  <img src="https://www.redmineflux.com/wp-content/uploads/2025/10/Redmineflux-logo.svg" alt="Redmineflux" width="280" />
</p>

<h1 align="center">Redmineflux Mentions Plugin</h1>

<p align="center">
  <strong>@mention team members in issues and wiki pages. Direct attention instantly — conversation stays in Redmine.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Redmine-6.x%20%7C%207.x-red?logo=ruby&logoColor=white" alt="Redmine 6.x | 7.x" />
  <img src="https://img.shields.io/badge/Ruby-3.1%E2%80%934.0-CC342D?logo=ruby&logoColor=white" alt="Ruby 3.1–4.0" />
  <img src="https://img.shields.io/badge/Rails-7.2%20%7C%208.1-CC0000?logo=rubyonrails&logoColor=white" alt="Rails 7.2 | 8.1" />
  <img src="https://img.shields.io/badge/JavaScript-ES6+-F7DF1E?logo=javascript&logoColor=black" alt="JavaScript" />
  <img src="https://img.shields.io/badge/license-GPL%20v2-blue" alt="License: GPL v2" />
</p>

<p align="center">
  <a href="https://www.redmineflux.com/product/redmine-plugins/mentions/">Website</a> ·
  <a href="https://www.redmineflux.com/knowledge-base/">Knowledge Base</a> ·
  <a href="#installation">Installation</a>
</p>

---

## Redmine Compatibility

Redmine 6 and 7 use the same plugin code. Install the release branch for your Redmine major version (your Redmine version is shown under **Administration > Information**):

| Redmine | Plugin version | Branch to install |
|---------|----------------|-------------------|
| 7.x | 7.x.y (tags `v7.x.y`) | [`release/7.0.0`](https://github.com/zehntech/redmineflux-mentions-plugin/tree/release/7.0.0) |
| 6.x | 6.x.y (tags `v6.x.y`) | [`release/6.0.0`](https://github.com/zehntech/redmineflux-mentions-plugin/tree/release/6.0.0) |
| 5.x | 5.x.y (legacy, security fixes only) | [`release/5.0.0`](https://github.com/zehntech/redmineflux-mentions-plugin/tree/release/5.0.0) |

`master` is the development trunk. It is not meant for production installs; always install a release branch.

The 6.x and 7.x packages are built from the same code and have the same features. When you upgrade Redmine from 6.x to 7.x, replace the plugin with the `release/7.0.0` package.

---

## Overview

The Mentions Plugin e-mails people when they are mentioned in an issue description, an issue note or a wiki page. Write the mention symbol followed by a login (for example `@jsmith`), save, and every mentioned member of the project receives a "You were mentioned" e-mail with a link to the issue or wiki and the text that mentions them.

```
Type @login → Save the issue, note or wiki page → Mentioned project members get an e-mail
```

Redmine 5.0 and later already supports `@user` mentions with autocomplete. This plugin adds a dedicated mention e-mail on top of that, lets you choose a different mention symbol (`$ : ~ ! %`) with its own autocomplete, and shows mentions written with those symbols as links to the user.

---

## Screenshots

<!--
  SCREENSHOT GUIDELINES FOR CONTRIBUTORS:
  - Resolution: 1280 x 720 pixels (16:9 ratio)
  - Format: PNG (no JPEG — text must be crisp)
  - Browser: Use Chrome at 100% zoom, hide bookmarks bar
  - Data: Use demo data with realistic names (no "test123" or "admin")
  - Theme: Use the Redmineflux Scarlet or Daisy theme
  - Crop: Full page width, no browser chrome, no OS taskbar
  - Naming: mentions-{view-name}.png (lowercase, hyphens)
-->

### Mention Autocomplete in Issue Notes

![Mention Autocomplete](issue_mention_user.png)

*Type the mention symbol in the issue description or notes to pick a project member by login.*

### Wiki Page Mention

![Wiki Mention](mention_user.png)

*Mentions work in wiki page content — not just issues.*

### Plugin Configuration

![Plugin Settings](plugin_config.png)

*Choose the mention symbol on the plugin settings page. The screenshot is from an earlier version; the current list is `@ $ : ~ ! %`.*

---

## Features

### Mention e-mails
- **New issue** — every project member mentioned in the description gets an e-mail with a link to the issue, the name of the person who mentioned them, the date and the issue description.
- **Issue update** — when an issue update is saved (a note or a field change), members mentioned in the new note get an e-mail with the note text. Members mentioned in the issue description get the description e-mail again on every update.
- **Wiki page** — when a logged-in user creates or saves a wiki page, every project member mentioned in the page text gets an e-mail with a link to the project wiki and the page text. This happens on every save.
- **Who receives it** — only active members of the issue's or wiki's project who have an e-mail address. A mention of anyone else is ignored.
- **How a mention is matched** — the symbol and the exact login must form one word, followed by a space or a line break (for example `@jsmith`). Punctuation directly after the login, such as `@jsmith,`, does not match.
- Issues and notes created in other ways (REST API, imports, other plugins) also trigger the e-mails, because the plugin hooks into issue and journal creation.
- Several people can be mentioned in one description, note or page.

### Autocomplete
- With the default `@` symbol, the plugin adds no autocomplete of its own and Redmine core's `@` user autocomplete is used. This keeps core's `#` (issue) and `[[` (wiki page) autocomplete working.
- With any other symbol (`$ : ~ ! %`), typing the symbol in the issue description or notes, or in the wiki page editor, opens a list of logins of the project's active members who have an e-mail address. The list matches on login.
- On issue forms, this autocomplete is shown to users who may add or edit issues, and to administrators.

### Mention links
- In formatted text, `<symbol><login>` for an existing user that the viewer can see is shown as a link to the user's profile, labelled with the symbol and the user's full name.

### For administrators
- One setting: the mention symbol (see [Configuration](#configuration)).
- No database tables, no project module, no permissions and no routes of its own.

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| **Backend** | Ruby on Rails (Redmine plugin); patches on `Issue`, `Journal`, `WikiController` and `ApplicationHelper` |
| **Frontend** | Inline jQuery and the Tribute autocomplete library that Redmine core loads |
| **Notification Delivery** | ActionMailer, sent synchronously (`deliver_now`) through Redmine's mail delivery settings |
| **Database** | No tables or migrations of its own; works with the databases supported by Redmine |
| **Integration** | Redmine view hooks `view_issues_form_details_top` and `view_layouts_base_content` |

---

## Installation

### Prerequisites

- Redmine 6.x or 7.x (Redmine 5.x: the legacy [`release/5.0.0`](https://github.com/zehntech/redmineflux-mentions-plugin/tree/release/5.0.0) line)
- Ruby and Rails as required by your Redmine version (Rails comes with Redmine):

| Redmine | Ruby | Rails |
|---------|------|-------|
| 7.0 | 3.2 – 4.0 | 8.1 |
| 6.1 | 3.2 – 3.4 | 7.2 |
| 6.0 | 3.1 – 3.3 | 7.2 |
| 5.1 (legacy line) | 2.7 – 3.2 | 6.1 |

- Outgoing e-mail configured in Redmine (`email_delivery` in `config/configuration.yml`) for the mention e-mails

The plugin has no Gemfile and no migrations, so `bundle install` and `redmine:plugins:migrate` are not needed.

### Install

```bash
# 1. Put the plugin in the plugins directory. The folder must be named flux_mentions.
#    Use release/7.0.0 on Redmine 7.x, release/6.0.0 on Redmine 6.x.
cd /path/to/redmine/plugins
git clone -b release/7.0.0 https://github.com/zehntech/redmineflux-mentions-plugin.git flux_mentions

# 2. Restart Redmine (for example, for Passenger)
cd /path/to/redmine
touch tmp/restart.txt
```

### Verify

Navigate to **Administration > Plugins** — "Redmineflux Mentions plugin" should appear with a 7.x.y version on Redmine 7 or a 6.x.y version on Redmine 6.

---

## Configuration

**Administration > Plugins > Redmineflux Mentions plugin > Configure**

### General

| Setting | Values | Default | Description |
|---------|--------|---------|-------------|
| Select Mention Symbol (`symbol`) | `@` `$` `:` `~` `!` `%` | `@` | The symbol that marks a mention for the e-mails. With a symbol other than `@`, it is also the trigger for the plugin's autocomplete. |

### E-mail Delivery

- Mention e-mails use Redmine's mail delivery settings from `config/configuration.yml` and are sent immediately, while the issue, note or wiki page is being saved (never queued).
- Before each e-mail the plugin checks that an SMTP address is set. If it is empty, the e-mail is skipped and an "SMTP settings not configured" line is written to the Rails log.
- The sender is Redmine's **Emission email address** (**Administration > Settings > Email notifications**), read when Redmine starts. Restart Redmine after changing it.

---

## Permissions

The plugin defines no permissions and no project module.

- Mentions can be written by anyone who can already edit the issue description, add notes or edit wiki pages (core Redmine permissions).
- The plugin's autocomplete on issue forms (used only when the symbol is not `@`) is shown to users with the core **Add issues** or **Edit issues** permission, and to administrators.
- Sending the mention e-mail does not check any permission of the recipient beyond project membership (see [Known Limitations](#known-limitations)).

---

## FAQ

**Which Redmine versions are supported?**
Redmine 6.x and 7.x, from one codebase. Install [`release/7.0.0`](https://github.com/zehntech/redmineflux-mentions-plugin/tree/release/7.0.0) on Redmine 7 (plugin versions 7.x.y) or [`release/6.0.0`](https://github.com/zehntech/redmineflux-mentions-plugin/tree/release/6.0.0) on Redmine 6 (plugin versions 6.x.y); every release is a `v<major>.x.y` tag on that branch. Redmine 5.x is a legacy line on [`release/5.0.0`](https://github.com/zehntech/redmineflux-mentions-plugin/tree/release/5.0.0) that receives security fixes only.

**Can I mention someone who is not a watcher on the issue?**
Yes. Any active member of the issue's project with an e-mail address gets the mention e-mail, whether or not they watch the issue.

**Do mentioned users get added as watchers automatically?**
No. The plugin only sends the mention e-mail; it does not change the issue's watchers.

**Are mentions visible to all issue viewers?**
A mention is part of the description, note or wiki text, so anyone who can see that text sees it. There is no private mention capability.

**Does it work in wiki pages?**
Yes. Saving a wiki page e-mails the project members mentioned in it. With a symbol other than `@`, the plugin's autocomplete also works in the wiki editor.

**What happens if SMTP is not configured?**
If Redmine's SMTP address is empty, the plugin skips the e-mail and writes a line to the Rails log. An SMTP authentication error is also caught and logged. Any other delivery error is not caught: the issue, note or wiki page is not saved and the user sees an error.

**Can I change the @ symbol to something else?**
Yes, to one of `$ : ~ ! %` under **Administration > Plugins > Redmineflux Mentions plugin > Configure**. Mentions for the e-mails are then written with that symbol, and the plugin's own autocomplete opens when you type it.

**Will mentioned users get two e-mails?**
They can. With the default `@`, Redmine core's own issue notification may also reach the mentioned user, in addition to the plugin's "You were mentioned" e-mail.

---

## Known Limitations

- **No in-app notification badge** — Mention alerts are delivered by email only. There is no persistent in-app notification counter or mention inbox within Redmine's UI.
- **Synchronous delivery, no retry** — E-mails are sent during the save. A slow mail server slows the save, and there is no queue or retry.
- **Delivery errors block the save** — Only SMTP authentication errors are caught. Any other mail error stops the issue, note or wiki page from being saved.
- **Repeated e-mails** — Members mentioned in an issue description are e-mailed again on every update of that issue, and wiki mentions are e-mailed on every save of the page.
- **No preference or visibility checks** — Mention e-mails ignore each user's e-mail notification preference, and they include the description, note or page text without checking whether the recipient may view the issue or private notes.
- **E-mail is the only channel** — The plugin does not support push notifications, webhooks, or alternative delivery channels.
- **English e-mails** — Mail subjects, mail bodies and the settings label are in English only.
- **No private mentions** — All mentions in issue text and wiki pages are visible to anyone who can view that content.
- **Autocomplete matches on login name** — The plugin's autocomplete (symbols other than `@`) matches Redmine login names, not display names.
- **Links for all six symbols** — Mention links are rendered for all six symbols (`@ $ : ~ ! %`), whatever symbol is configured.
- **No mention analytics** — There is no report or dashboard showing mention activity, frequency, or response rates.

---

## Release Notes

See [RELEASE_NOTES.md](RELEASE_NOTES.md).

---

## Running Tests

```bash
cd /path/to/redmine

# All tests
bundle exec rails test plugins/flux_mentions/test

# Single file
bundle exec rails test plugins/flux_mentions/test/unit/rmn_001_branching_standard_test.rb
```

The current tests check the plugin registration and the **Administration > Plugins** page.

---

## Uninstall

The plugin has no database tables or migrations, so there is nothing to roll back.

```bash
cd /path/to/redmine

# Remove plugin
rm -rf plugins/flux_mentions

# Restart
touch tmp/restart.txt
```

The saved symbol setting stays in Redmine's settings table (`plugin_flux_mentions`) and has no effect once the plugin is removed.

---

## License

- The whole plugin (Ruby and ERB code, JavaScript, CSS, images and documentation) is licensed under the GNU General Public License v2 – see [`LICENSE`](LICENSE) and [`LICENSING-NOTICE.txt`](LICENSING-NOTICE.txt).
- Third-party libraries keep their own licences – see [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md).
- "Redmineflux" and its logo are trademarks of Zehntech Technologies Inc.

---

## Support

| Channel | Link |
|---------|------|
| Knowledge Base | [redmineflux.com/knowledge-base](https://www.redmineflux.com/knowledge-base/) |
| Email | support@redmineflux.com |
| Website | [redmineflux.com](https://www.redmineflux.com) |

## More from Redmineflux

This plugin is free. Redmineflux also makes paid Redmine plugins, bundles and a managed Redmine Cloud:

- **Paid plugins** – Agile Board, Gantt Chart, Timesheet, Helpdesk, Test Case Management, Invoice and more: [see all plugins and prices](https://www.redmineflux.com/redmine-plugins-pricing/)
- **Bundles** – several plugins together at a lower price: [compare bundles](https://www.redmineflux.com/redmine-plugin-combos-pricing/)
- **Managed Redmine Cloud** – Redmine with our plugins, hosted and maintained for you: [Redmineflux Cloud](https://www.redmineflux.com/cloud-redmine/)
- **AI for Redmine** – Crux Chat, Crux Agents and the MCP Server: [AI project management for Redmine](https://www.redmineflux.com/ai-project-management-for-redmine/)

**Need help?** GitHub issues are turned off for this repository. Please email
support@redmineflux.com or use the [contact page](https://www.redmineflux.com/contact-us/).
Plugin page: [Mentions plugin on redmineflux.com](https://www.redmineflux.com/product/redmine-plugins/mentions/)

---

<p align="center">
  <img src="https://www.redmineflux.com/wp-content/uploads/2025/10/Redmineflux-logo.svg" alt="Redmineflux" width="140" />
</p>

<p align="center">
  Redmine plugins for modern teams.<br/>
  Built by <a href="https://www.zehntech.com">Zehntech Technologies Inc.</a>
</p>

<p align="center">
  <a href="https://www.redmineflux.com">Website</a> ·
  <a href="https://www.redmineflux.com/redmine-plugin-combos-pricing/#all-plugins">All Plugins</a> ·
  <a href="https://www.redmineflux.com/about-us/">About Us</a>
</p>
