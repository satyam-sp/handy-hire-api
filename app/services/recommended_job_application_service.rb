class RecommendedJobApplicationService
  def initialize(instant_job)
    @instant_job = instant_job
    @applications = instant_job.instant_job_applications.includes(:employee)
  end

  def call
    scored_apps = @applications.map do |app|
      {
        app: app,
        score: calculate_score(app)
      }
    end

    recommended = scored_apps.max_by { |a| a[:score] }
    return recommended[:app]


  end

  private
  def price_score(app)
    job_price = @instant_job.price.to_f
    app_price = app.final_price.to_f
    diff = (app_price - job_price)
  
    if diff <= 0
      # Lower or equal price is better, max score
      5 + diff.abs.clamp(0, 5) # small discount adds bonus
    else
      # More expensive is worse
      [5 - diff, 0].max
    end
  end


  def calculate_score(app)
    employee = app.employee

    rating_score = employee.rating.to_f
    fraud_penalty = 5 - employee.fraud_level.to_i

    price_score = price_score(app)

    slot_score = time_slot_similarity(app.slot_time, @instant_job.slot_time)

    # Total weighted score (tune weights as needed)
    (rating_score * 2) + (fraud_penalty * 1.5) + price_score + slot_score
  end

  def time_slot_similarity(slot1, slot2)
    # Example: "2pm - 3pm" → convert to minutes
    start1, end1 = slot1.downcase.split(' - ').map { |t| parse_time(t) }
    start2, end2 = slot2.downcase.split(' - ').map { |t| parse_time(t) }

    diff = (start1 - start2).abs + (end1 - end2).abs
    [5 - (diff / 15.0), 0].max  # 5 is best, 0 worst
  end

  def parse_time(tstr)
    Time.parse(tstr).hour * 60 + Time.parse(tstr).min
  rescue
    0
  end
end
