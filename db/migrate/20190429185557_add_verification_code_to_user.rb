class AddVerificationCodeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :verification_code, :integer
  end
end
