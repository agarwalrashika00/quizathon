Rails.application.config.to_prepare do

  ActionText::RichText.class_eval do
    def self.ransackable_attributes(*)
      ['body']
    end

    def self.ransackable_associations(auth_object = nil)
      ["embeds_attachments", "embeds_blobs", "record"]
    end
  end

end
