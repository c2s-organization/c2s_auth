class NotifyService
  require 'httparty'

  NOTIFICATION_URL = "#{ENV["URL_MS_NOTIFICATION"]}/notifications".freeze

  def self.call(title, body)
    # TODO: Mover para HabbitMQ
    title = "Auth: #{title}"
    body = { title: title, body: body }
    HTTParty.post(NOTIFICATION_URL, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end
end
