class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  Payjp.api_key = ENV.fetch('PAYJP_PRIVATE_KEY')
  
  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  def import
    if current_user.tasks.import(params[:file])
      redirect_to tasks_url, notice: "タスクを追加しました"
    else
      redirect_to tasks_url, notice: "CSVファイルを選択してください"
    end
  end

  def plan
    @user = current_user
    if @user.subscription
      subscription = Payjp::Subscription.retrieve(@user.subscription)
      @plan_name = subscription[:plan][:name]
    end
  end

  def check_plan
    @user = current_user

    plan = params.require(:user).permit(:plan)[:plan]

    plan_remote_id = User::PLANS_REMOTE[plan]

    customer = Payjp::Customer.create(card: params["payjp-token"])
    @user.customer = customer[:id]

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
      plan:     plan_remote_id,
    )
    @user.subscription = subscription[:id]
    @user.premium = true
    if @user.save
      redirect_to tasks_url, notice: "【プレミアムユーザー】#{User::PLANS[plan]}プランに申し込みました。"
    else
      render :plan
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def create
    @task = current_user.tasks.new(task_params)
    
    if params[:back].present?
      render :new
      return
    end

    if @task.save
      TaskMailer.creation_email(@task, current_user).deliver_now
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    # redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
    head :no_content
  end

  private
  def task_params
    if current_user.premium?
      params.require(:task).permit(:name, :description, :special, :image)
    else
      params.require(:task).permit(:name, :description, :image)
    end
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
