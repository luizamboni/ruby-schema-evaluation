ENV["RUBY_DEBUGGER_DISABLE"] = "1"

require "rspec"
require_relative "support/messages/dry_validataion_message"
require_relative "support/messages/dry_struct_message"
require_relative "support/messages/sorbet_struct_message"
require_relative "support/messages/easy_talk_message"
require_relative "support/messages/active_model_message"
