class Admin::UsersController < ApplicationController
  before_action :require_admin

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def skill_proficiency_edit
    @user = User.find(params[:id])
    @skillsUsers = @user.skillsUsers.includes(:skill)
  end

  def skill_proficiency_update
    @user = User.find(params[:id])
    @user.set_proficiency!(params[:proficiency])
    redirect_to admin_user_path(@user), notice: "ユーザー「#{@user.name}」を更新しました。"
  end

  def skill_edit
    @user = User.find(params[:id])
    @skillhash_by_kind_name = Skill.skillhash_by_kind_name
    @users_skills = @user.skills.to_ary
  end

  def skill_update
    @user = User.find(params[:id])
    @user.update_skill_names!(params[:skills])
    redirect_to admin_user_path(@user), notice: "ユーザー「#{@user.name}」を更新しました。"
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー「#{@user.name}」を更新しました。"
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を削除しました。"
  end

  def index
    if params[:q]
      params[:q]["skills_name_cont_any"] = parameter_conversion(params[:q]["skills_name_cont_any"])
      params[:q]["skills_name_in"] = parameter_conversion(params[:q]["skills_name_in"])
      params[:q]["skill_names_cont"] = parameter_conversion(params[:q]["skill_names_cont"]).join(',')
      
    end

    # SQL文を生で書いても絞り込む方法は無い
    # OR検索でしか件数が取れない
    # User.find_by_sql("SELECT users.* FROM users WHERE id in (
    #   SELECT skills_users.user_id FROM skills_users INNER JOIN skills ON skills_users.skill_id = skills.id WHERE skills.name = 'XD' OR skills.name = 'PHP'
    # );").size

    # User.find_by_sql("SELECT DISTINCT users.* FROM users WHERE users.id in (SELECT DISTINCT skills_users.user_id FROM skills_users WHERE skills_users.skill_id in (SELECT skills.id FROM skills WHERE skills.name in ('XD', 'PHP')))").count
    
    # OR 検索したものをコレクションをまわして絞り込む方法
    # 微妙なので没
    if params[:q] && params[:q]["skills_name_in"]
      @q = User.ransack(params[:q])
      users = 
        @q.result(distinct: true).includes([:skillsUsers, :skills]).map do |user|
          skill_names = user.skills.map(&:name)
          ret =
            params[:q]["skills_name_in"].all? do |w|
              skill_names.include?(w)
            end
          user if ret
        end.compact
      params[:q]["id_eq_any"] = users.map(&:id)
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true).includes([:skillsUsers, :skills]).page(params[:page]).per(10)
      # @users = @q.result(distinct: true).page(params[:page]).per(10)
    else 
      @q = User.ransack(params[:q])
      # @users = @q.result(distinct: true).includes([:skillsUsers, :skills]).page(params[:page]).per(10)
      @users = @q.result(distinct: true).page(params[:page]).per(10)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :locale, :premium, :admin, :password, :password_confirmation)
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def parameter_conversion(params)
    if params
      params&.split(/[\s 　,]/)&.sort_by{|v|v}.map do |v|
        if v.blank?
          nil
        else
          v
        end
      end.compact
    end
  end
end
