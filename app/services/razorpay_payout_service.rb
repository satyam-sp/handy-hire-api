# app/services/razorpay_payout_service.rb
class RazorpayPayoutService
  def initialize(user, amount)
    @user = user
    @amount = amount * 100 # in paise
  end

  def send_payout
    account = get_or_create_contact_and_fund_account

    payout = Razorpay::Payout.create(
      account_number: 'your_account_number',
      fund_account_id: account[:fund_account_id],
      amount: @amount,
      currency: 'INR',
      mode: 'IMPS',
      purpose: 'payout',
      queue_if_low_balance: true
    )

    { status: 'success', id: payout.id }
  rescue => e
    { status: 'error', error: e.message }
  end

  def get_or_create_contact_and_fund_account
    contact = Razorpay::Contact.create(
      {
        name: @user.full_name,
        email: @user.email,
        contact: @user.mobile_number,
        type: 'employee',
        reference_id: "user_#{@user.id}",
        notes: { role: 'Employee Withdrawal' }
      }
    )

    fund_account = Razorpay::FundAccount.create(
      {
        contact_id: contact.id,
        account_type: 'bank_account',
        bank_account: {
          name: @user.full_name,
          ifsc: @user.bank_ifsc_code,
          account_number: @user.bank_account_number
        }
      }
    )


    # Create contact and fund account on Razorpay and return fund_account_id
  end
end
