class CreateAdminUser < ActiveRecord::Migration
  def up
    user = User.create(
      email: 'admin@example.com',
      password: 'Secret5!',
      password_confirmation: 'Secret5!'
    )
    user.roles << :admin
    user.update_attribute(:confirmed_at, Time.now.utc)
  end
end
