# frozen_string_literal: true

if Rails.env.development? || Rails.env.profile?
  require "rack-mini-profiler"

  # The initializer was required late, so initialize it manually.
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
