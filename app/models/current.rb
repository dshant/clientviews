class Current < ActiveSupport::CurrentAttributes
  attribute :account, :user, :yoha

  def user=(user)
    super
    self.account = user.account
  end

  def yoha=(yoha)
    super
  end
end
