require "csv"

class Countries::ImportJob < ApplicationJob
  queue_as :default

  def perform(blob_signed_id)
    blob = ActiveStorage::Blob.find_signed(blob_signed_id)

    blob.download do |data|
      encoded_data = data.force_encoding("ASCII-8BIT").encode("UTF-8", invalid: :replace, undef: :replace, replace: "?")
      CSV.parse(encoded_data, headers: true) do |row|
        Countries::CreateRecordJob.perform_later(
          name: row["Country"],
          flag_url: row["Flag URL"]
        )
      end
    end
  ensure
    blob.purge_later
  end
end
