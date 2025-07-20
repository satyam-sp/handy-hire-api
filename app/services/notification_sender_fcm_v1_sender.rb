require 'net/http'
require 'uri'
require 'json'
require 'googleauth'

class NotificationSenderFcmV1Sender
  SERVICE_ACCOUNT_KEY_PATH = Rails.root.join('config', 'handyhire-fbservice.json').freeze
  PROJECT_ID = JSON.parse(File.read(SERVICE_ACCOUNT_KEY_PATH))['project_id']

  def self.generate_access_token
    key_content = File.read(SERVICE_ACCOUNT_KEY_PATH)
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(key_content),
      scope: ['https://www.googleapis.com/auth/firebase.messaging']
    )
    authorizer.fetch_access_token!['access_token']
  end

  def self.send_push_notification(device_token, title, body, data = {})
    access_token = generate_access_token

    uri = URI("https://fcm.googleapis.com/v1/projects/#{PROJECT_ID}/messages:send")

    payload = {
      message: {
        token: device_token,
        notification: {
          title: title,
          body: body,
        },
        data: data.transform_values(&:to_s)
      }
    }

    headers = {
      'Authorization' => "Bearer #{access_token}",
      'Content-Type' => 'application/json'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = payload.to_json

    response = http.request(request)
    Rails.logger.info "FCM V1 Response: #{response.code} - #{response.body}"
    JSON.parse(response.body)

  rescue StandardError => e
    Rails.logger.error "Error sending FCM V1 notification: #{e.message}"
    { error: e.message }
  end

  def self.send_multicast_notification(device_tokens, title, body, data = {})
  responses = []

  device_tokens.each do |token|
    response = send_push_notification(token, title, body, data)
    responses << { token: token, response: response }
  end

  responses
  end
end
