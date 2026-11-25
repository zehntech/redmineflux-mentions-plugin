module Patch
  module IssueControllerPatch
    def self.included(base)
      base.class_eval do
      
        after_create :send_mail



        def send_mail
          if self.journalized.is_a?(Issue)
            issue = self.journalized
            project = self.journalized.project
            mention_symbol = Setting.plugin_flux_mentions['symbol']

            # Extract all mentioned logins from description and notes
            all_text = "#{self.journalized.description} #{self.notes}".to_s
            mentioned_logins = all_text.split(' ').map { |word| word.start_with?(mention_symbol) ? word.delete_prefix(mention_symbol) : nil }.compact.uniq
            return if mentioned_logins.empty?

            # Load only mentioned users from database with SQL filtering
            users = project.users.where(type: 'User', login: mentioned_logins).joins(:email_address).where.not(email_addresses: { address: [nil, ""] }).select("users.id", "users.login")

            # Scan description for mentions
            if self.journalized.description.present?
              mentioned_users = users.select { |u| self.journalized.description.split(' ').include?("#{mention_symbol}#{u.login}") }
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

            # Scan notes for mentions
            if self.notes.present?
              mentioned_users = users.select { |u| self.notes.split(' ').include?("#{mention_symbol}#{u.login}") }
              mentioned_users.each do |mentioned_user|
                if ActionMailer::Base.smtp_settings[:address].present?
                  begin
                    IssueMailer.notes_notification(issue, self, mentioned_user).deliver_now
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
end

Journal.send(:include, Patch::IssueControllerPatch)
