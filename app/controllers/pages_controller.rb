class PagesController < ApplicationController
  authorize_resource :class => PagesController
  
  def index
    if params[:q].present?
      @activities = Activity.where('name like ?', "%#{params[:q]}%")
    else
      @activities = []
    end

    @users = User.all
    if user_signed_in?
      @user_activities = Activity.where.not(id: current_user.activities.pluck(:id))
      @contacts = current_user.contacting
    end
    @promotes = PromoteActivity.where(payed: true)


    @sucesos = []
      if user_signed_in?

    @contacts.each do |c|
      User.find(c.followed_id).user_activity.each do |suc|
        @sucesos << suc
      end
    end
    current_user.user_activity.each do |suceso|
       @sucesos << suceso
    end
    @sucesos.sort_by {|event| event.created_at}
    @sucesos.reverse!
  end

  end  

  def user_page
    @user = User.find(params[:user_id])
    @categories = Category.all

    @act_realizadas = UserActivity.realizadas
    @act_user_realizadas = @act_realizadas.where(user_id: params[:user_id]).order(:created_at).reverse
    
    @act_pendientes = UserActivity.pendientes
    @act_user_pendientes = @act_pendientes.where(user_id: params[:user_id]).order(:created_at).reverse

    @act_por_realizar = UserActivity.por_realizar
    @act_user_por_realizar = @act_por_realizar.where(user_id: params[:user_id]).order(:created_at).reverse

    if user_signed_in?
      if current_user.contacting.find_by(followed_id: @user.id) != nil
        @following = true
      else
        @following = false
      end
    end
    


  end

end
