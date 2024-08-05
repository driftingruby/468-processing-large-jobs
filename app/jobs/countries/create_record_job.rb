require "open-uri"

class Countries::CreateRecordJob < ApplicationJob
  queue_as :default

  def perform(name:, flag_url:)
    country = Country.find_or_initialize_by(name: name)
    country.flag.attach(
      io: URI.open(flag_url),
      filename: File.basename(URI.parse(flag_url).path)
    )
    country.save!
  end
end
