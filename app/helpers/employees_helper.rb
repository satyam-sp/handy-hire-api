module EmployeesHelper
  def avatar_url(user)
    if user.avatar.attached?
      url_for(user.avatar)
    else
      asset_path('employee-avatar.svg')
    end
  end
end