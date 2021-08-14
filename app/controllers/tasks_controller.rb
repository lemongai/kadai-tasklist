class TasksController < ApplicationController
#  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
#  before_action :ensure_user, {only: [:show, :edit, :update, :destroy]}
  before_action :correct_user, {only: [:show, :edit, :update, :destroy]}
  
#  def ensure_user
#    if @current_user.id != @task.user_id
#      redirect_to root_url
#    end
#  end
  
  def index
#    if logged_in?
#      @task = current_user.tasks.build  # form_with 用
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
#    end
  end
  
  def show
  end

  def new
    @task = Task.new 
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      flash[:success] = 'タスク が正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスク が登録されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスク は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスク は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'タスク は正常に削除されました'
    redirect_to tasks_url
  end
  
  private

#  def set_task
#    @task = Task.find(params[:id])
#  end

#タスク投稿ユーザと合致していることを確認
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
end
