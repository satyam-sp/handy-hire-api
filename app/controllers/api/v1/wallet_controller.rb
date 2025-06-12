# app/controllers/wallet_controller.rb
class WalletController < ApplicationController
  def withdraw
    user = User.find(params[:user_id])
    amount = params[:amount].to_i

    if user.wallet_balance < amount
      return render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
    end

    payout = RazorpayPayoutService.new(user, amount).send_payout

    if payout[:status] == 'success'
      user.wallet_balance -= amount
      user.save

      Transaction.create!(
        user: user,
        transaction_type: 'withdrawal',
        amount: amount,
        status: 'success',
        reference_id: payout[:id]
      )

      render json: { message: 'Withdrawal initiated', payout_id: payout[:id] }, status: :ok
    else
      render json: { error: payout[:error] }, status: :unprocessable_entity
    end
  end
end
