class Api::V1::EmployeesController < ApplicationController

  before_action :authorize_request, only: [:update_profile,:get_employee, :update_avatar]
  before_action :authenticate_employee, only: [:update_profile,:get_employee, :update_avatar]

  # ✅ Login via username OR email
  def login
    mobile = params[:mobile_number].to_s.strip
    mobile = "+91#{mobile}" unless mobile.start_with?('+91')
    employee = Employee.find_by(mobile_number: mobile)
    if employee&.authenticate(params[:password])
      render json: {
        message: "Login successful",
        employee: Api::V1::EmployeeSerializer.new(employee).serializable_hash[:data][:attributes],
        token: generate_token(employee)
      }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end     

  end


  def get_employee
    if current_employee
      render json: Api::V1::EmployeeSerializer.new(current_employee).serializable_hash[:data][:attributes]
    else
      render json: {error: 'Employee not found'}, status: :unauthorized
    end
  end

  

  # ✅ Step-by-Step Employee Registration
  def register_step
    employee = Employee.new(mapped_employee_params)
    if employee.save
      render json: { message: 'Employee created successfully',  employee: employee_data(employee), token: generate_token(employee) }, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update_avatar
    if params[:avatar].present?
      current_employee.avatar.attach(params[:avatar])
      render json: { message: "Avatar updated", url: url_for(current_employee.avatar) }, status: :ok
    else
      render json: { error: "No avatar uploaded" }, status: :unprocessable_entity
    end
  end


  # ✅ Update Profile (Including Profile Photo)
  def update_profile
    if params[:profile_photo].present?
      @current_employee.profile_photo.attach(params[:profile_photo])
    end

    if @current_employee.update(employee_params)
      render json: { message: "Profile updated successfully", employee: employee_data(@current_employee) }, status: :ok
    else
      render json: { error: @current_employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Step 1: Basic Information
  def handle_basic_info
    required_fields = [:full_name, :mobile_number, :username, :password, :password_confirmation]
    return missing_params(required_fields) unless params_present?(required_fields)

    @employee ||= Employee.new(mobile_number: params[:mobile_number])

    if @employee.persisted? && @employee.registration_step >= 1
      return render json: { error: "Step 1 already completed" }, status: :unprocessable_entity
    end

    @employee.assign_attributes(
      full_name: params[:full_name],
      username: params[:username],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      date_of_birth: params[:date_of_birth],
      gender: params[:gender],
      email: params[:email],
      registration_step: 1
    )

    @employee.profile_photo.attach(params[:profile_photo]) if params[:profile_photo].present?

    if @employee.save
      render json: { message: "Step 1 completed", employee_id: @employee.id }, status: :ok
    else
      render json: { error: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Step 2: Identity & Verification
  def handle_identity_verification
    required_fields = [:aadhaar_number, :address]
    return missing_params(required_fields) unless params_present?(required_fields)

    return render json: { error: "Complete Step 1 first" }, status: :unprocessable_entity if @employee.registration_step < 1

    @employee.update!(
      aadhaar_number: params[:aadhaar_number],
      pan_number: params[:pan_number],
      address: params[:address],
      registration_step: 2
    )

    render json: { message: "Step 2 completed" }, status: :ok
  end

  # Step 3: Job Details
  def handle_job_details
    required_fields = [:job_categories, :experience_years, :expected_pay]
    return missing_params(required_fields) unless params_present?(required_fields)

    return render json: { error: "Complete Step 2 first" }, status: :unprocessable_entity if @employee.registration_step < 2

    @employee.update!(
      job_categories: params[:job_categories],
      experience_years: params[:experience_years],
      work_location: params[:work_location],
      availability: params[:availability],
      expected_pay: params[:expected_pay],
      registration_step: 3
    )

    render json: { message: "Registration completed successfully!" }, status: :ok
  end



  # Generate authentication token
  def generate_token(employee)
    payload = { employee_id: employee.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # Decode authentication token
  def decode_token(token)
    return unless token.present?
    begin
      JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    rescue
      nil
    end
  end

  # Check required fields
  def params_present?(fields)
    fields.all? { |field| params[field].present? }
  end

  def missing_params(fields)
    missing = fields.select { |field| params[field].blank? }
    render json: { error: "Missing required fields", missing_fields: missing }, status: :unprocessable_entity
  end

  # Fetch employee or return error
  

  # Strong Parameters
  def mapped_employee_params
    # Merge flat and nested `employee` keys, preferring top-level ones if both exist
    merged_params = params.permit!.to_h.deep_merge(params[:employee] || {})

    {
      full_name: merged_params["fullName"],
      mobile_number: merged_params["mobileNumber"],
      gender: merged_params["gender"],
      address: merged_params["address"],
      date_of_birth: merged_params["dateOfBirth"],
      password: params[:password],
      password_confirmation: params[:confirmPassword],
      current_address: merged_params["currentAddress"],
      same_as_permanent_address: merged_params["sameAsPermanentAddress"],
      experience_years: merged_params["experience_years"],
      work_location: merged_params["work_location"],
      expected_pay: merged_params["expected_pay"],
      availability: merged_params["job_type"], # maps parttime -> part-time
      job_category_ids: merged_params['job_categories']
    }
  end
  # ✅ Include Profile Photo URL in Responses
  def employee_data(employee)
    {
      id: employee.id,
      full_name: employee.full_name,
      email: employee.email,
      date_of_birth: employee.date_of_birth,
      gender: employee.gender,
      # profile_photo_url: employee.profile_photo.attached? ? url_for(employee.profile_photo) : nil,
      aadhaar_number: employee.aadhaar_number,
      pan_number: employee.pan_number,
      address: employee.address,
      job_categories: employee.job_categories,
      experience_years: employee.experience_years,
      work_location: employee.work_location,
      availability: employee.availability,
      expected_pay: employee.expected_pay
    }
  end


  
  def authenticate_employee
    unless current_employee
      render json: { error: "Unauthorized Employee" }, status: :unauthorized
    end
  end

  
end
