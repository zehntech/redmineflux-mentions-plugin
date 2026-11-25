module Patch
  module IssueCreationPatch
    def self.included(base)
      base.class_eval do
        after_create :send_mail_on_create
        
        def send_mail_on_create
          issue = self
          project = self.project
          mention_symbol = Setting.plugin_flux_mentions['symbol']

          # Scan description for mentions
          if issue.description.present?
            mentioned_logins = issue.description.split(' ').map { |word| word.start_with?(mention_symbol) ? word.delete_prefix(mention_symbol) : nil }.compact.uniq
            return if mentioned_logins.empty?

            users = project.users.where(type: 'User', login: mentioned_logins).joins(:email_address).where.not(email_addresses: { address: [nil, ""] }).select("users.id", "users.login")
            mentioned_users = users.select { |u| issue.description.split(' ').include?("#{mention_symbol}#{u.login}") }
            mentioned_users.each do |mentioned_user|
              if ActionMailer::Base.smtp_settings[:address].present?
                begin
                  IssueMailer.new_issue_description(issue, self, mentioned_user).deliver_now
                rescue Net::SMTPAuthenticationError => e
                  Rails.logger.error "SMTP Error: #{e.message}"
                end
              else
                Rails.logger.info "SMTP settings not configured. Email not sent."
              end
            end
          end
        end
      end
    end
  end
end

Issue.send(:include, Patch::IssueCreationPatch)