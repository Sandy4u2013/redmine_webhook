module RedmineWebhook
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
    
        after_create :send_create_webhook
      end
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def send_create_webhook
        webhook = Webhook.where(:project_id => self.project).first
        return unless webhook
    
        helper = RedmineWebhook::Helper.new
        helper.post(webhook, helper.issue_to_json(self))
      end
    end
  end
end