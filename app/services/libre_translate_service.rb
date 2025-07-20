# app/services/libre_translate_service.rb
class LibreTranslateService
  include HTTParty
  base_uri "https://libretranslate.com"

  def translate_batch(texts, from: "en", to: "hi")
    joined_text = texts.join("|||")

    response = self.class.post("/translate",
      headers: { "Content-Type" => "application/json" },
      body: {
        q: joined_text,
        source: from,
        target: to,
        format: "text"
      }.to_json
    )
    if response.success?
      translated = JSON.parse(response.body)["translatedText"]
      translated.split("|||").map(&:strip)
    else
      texts.map { "Translation Error" }
    end
  end
end
