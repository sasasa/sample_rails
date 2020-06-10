class Card
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :number, :month, :year, :cvc, :name, :plan
  
  PLANS = {"1"=>"月次", "2"=>"年次"}
  PLANS_REMOTE = {"1"=>'pln_6c04034830aa5ad616c5447b1936', "2"=>'pln_3016b66e77175593f980c57b7f90'}

  validates :number, presence: true
  validates :number, numericality: { only_integer: true }, allow_blank: true 
  validates :number, :length => { :is => 16 }, allow_blank: true 
  
  validates :month, presence: true
  validates :month, :numericality => { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 12
  }, allow_blank: true 

  validates :year, presence: true
  validates :year, presence: true, :numericality => { 
    only_integer: true,
    greater_than_or_equal_to: Time.zone.now.year
  }, allow_blank: true 
  
  validates :cvc, presence: true
  validates :cvc, numericality: { only_integer: true }, allow_blank: true 
  validates :cvc, presence: true, :length => { :is => 3 }, allow_blank: true 
  validates :name, presence: true

  def save(current_user, payjp_token)
    validate && post(current_user, payjp_token)
  end

  def post(current_user, payjp_token)
    # APIに直接値を送るのを許可してくれないのでこの方法は使えない。
    # token = Payjp::Token.create(
    #   card: {
    #     number:    number,
    #     cvc:       cvc,
    #     exp_year:  year,
    #     exp_month: month,
    #   }
    # )

    customer = Payjp::Customer.create(card: payjp_token)
    # customer = Payjp::Customer.create(card: token[:id])
    current_user.customer = customer[:id]

    # charge = Payjp::Charge.create(
    #   :amount => 500,
    #   :card => params["payjp-token"], // テンポラリトークン
    #   :currency => 'jpy',
    # )
    # plan = Payjp::Plan.create(
    #   amount:   500,
    #   interval: 'month',
    #   currency: 'jpy'
    # )
    # plan[:id]

    subscription = Payjp::Subscription.create(
      customer: customer[:id],
      plan:     PLANS_REMOTE[plan],
    )
    current_user.subscription = subscription[:id]
    current_user.premium = true
    current_user.save
  end
end

