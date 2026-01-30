ENV["RUBY_DEBUGGER_DISABLE"] = "1"

require "rspec"
require_relative "support/messages/dry_validataion_message"
require_relative "support/messages/dry_struct_message"
require_relative "support/messages/sorbet_struct_message"
require_relative "support/messages/easy_talk_message"
require_relative "support/messages/active_model_message"
require_relative "support/messages/active_record_message"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.data_source_exists?("active_record_messages")
    create_table :active_record_messages, force: true do |t|
      t.string :error
      t.string :message
      t.text :details
    end
  end
end
